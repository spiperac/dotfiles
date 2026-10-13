#!/usr/bin/env bash
# Compare what the Ansible roles declare against what is actually installed.
#
#   ./scripts/reconcile.sh          # report drift
#   ./scripts/reconcile.sh --prune  # also list orphan removal candidates
#   ./scripts/reconcile.sh --purge  # remove undeclared packages (asks first)
#
# Two directions of drift:
#   UNDECLARED  installed explicitly, but no role asks for it -> add it to a role
#   MISSING     a role declares it, but it is not installed   -> re-run the playbook
#
# Roles are read from ansible/site.yml, desktop sessions from
# ansible/host_vars/<host>.yml (host: DOTFILES_HOST, default this machine's hostname).
# Packages of a session the host does not pick are not expected, so they
# surface as UNDECLARED and become purge-eligible.
set -euo pipefail

# Python sorts by codepoint; sort/comm sort by locale. Force byte order so the
# two agree, otherwise comm reports "input is not in sorted order".
export LC_ALL=C

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST="${DOTFILES_HOST:-$(uname -n)}"
HOST="${HOST%%.*}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if command -v pacman >/dev/null; then
  DISTRO=arch
  REMOVE=(sudo pacman -Rns)
elif command -v dpkg-query >/dev/null && [[ -r /etc/debian_version ]]; then
  DISTRO=debian
  REMOVE=(doas apt-get purge)
else
  echo "reconcile.sh supports Arch and Debian only." >&2
  exit 1
fi

# Pull the declared names out of the role vars, keyed by what kind of thing they
# are. Only *_packages feed the package manager comparison; flatpak is reported
# separately because it is installed by a different manager.
python3 - "$REPO_DIR" "$TMP" "$HOST" "$DISTRO" <<'PY'
import pathlib, re, sys, yaml

repo, tmp, host, distro = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2]), sys.argv[3], sys.argv[4]
ansible = repo / "ansible"
buckets = {"packages": set(), "flatpaks": set()}

host_vars = ansible / "host_vars" / f"{host}.yml"
if not host_vars.exists():
    sys.exit(f"Host '{host}' has no ansible/host_vars/{host}.yml (set DOTFILES_HOST).")
sessions = (yaml.safe_load(host_vars.read_text()) or {}).get("desktop_sessions", [])

playbook = yaml.safe_load((ansible / "site.yml").read_text()) or []
roles = []
for play in playbook:
    for entry in play.get("roles", []) or []:
        roles.append(entry if isinstance(entry, str) else entry.get("role"))
    for task in play.get("post_tasks", []) or []:
        if isinstance(task, dict) and task.get("ansible.builtin.import_role"):
            roles.append(task["ansible.builtin.import_role"]["name"])

for f in sorted((ansible / "roles").glob(f"*/vars/{distro}.yaml")):
    if f.parts[-3] not in roles:
        print(f"WARNING: role {f.parts[-3]} has vars but is absent from ansible/site.yml", file=sys.stderr)

# Installed outside the *_packages lists: flatpak itself and the CPU microcode.
flatpak_package = (yaml.safe_load((ansible / "group_vars" / "all.yml").read_text()) or {}).get("flatpak_package")
vendor = next((l.split(":", 1)[1].strip() for l in open("/proc/cpuinfo") if l.startswith("vendor_id")), None)

for role in roles:
    f = ansible / "roles" / role / "vars" / f"{distro}.yaml"
    if not f.exists():
        continue
    data = yaml.safe_load(f.read_text()) or {}
    flatpak_package = data.get("flatpak_package", flatpak_package)
    ucode = data.get("base_ucode") or {}
    if vendor in ucode:
        buckets["packages"].add(ucode[vendor])
    for key, val in data.items():
        if not isinstance(val, list):
            continue
        session = re.match(r"desktop_(sway|gnome)_", key)
        if session and session.group(1) not in sessions:
            continue
        for suffix, bucket in (("_packages", "packages"), ("_flatpaks", "flatpaks")):
            if key.endswith(suffix):
                buckets[bucket].update(str(v) for v in val)
                break

if flatpak_package:
    buckets["packages"].add(flatpak_package)

(tmp / "sessions").write_text(", ".join(sessions) or "none")

for name, items in buckets.items():
    (tmp / f"declared_{name}").write_text("".join(f"{i}\n" for i in sorted(items)))
PY

cp "$TMP/declared_packages" "$TMP/expected"
: > "$TMP/declared_groups"

case "$DISTRO" in
  arch)
    pacman -Qeq | sort > "$TMP/installed"
    pacman -Qq  | sort > "$TMP/installed_all"
    pacman -Qi > "$TMP/db" 2>/dev/null

    # A group is satisfied when its members are present; the group name itself is
    # never an installed package, so it must not count as MISSING.
    pacman -Sg 2>/dev/null | sort -u > "$TMP/groups" || : > "$TMP/groups"
    comm -12 "$TMP/declared_packages" "$TMP/groups" > "$TMP/declared_groups"
    mapfile -t groups < <(cat "$TMP/declared_groups"; echo base; echo base-devel)
    pacman -Sqg "${groups[@]}" 2>/dev/null >> "$TMP/expected" || true
    ;;
  debian)
    apt-mark showmanual | sort > "$TMP/installed"
    dpkg-query -W -f='${db:Status-Abbrev}\t${Package}\n' | awk -F'\t' '$1 ~ /^ii/ {print $2}' | sort -u > "$TMP/installed_all"
    dpkg-query -W -f='${db:Status-Abbrev}\t${Package}\t${Provides}\t${Pre-Depends}, ${Depends}, ${Recommends}\n' \
      | awk -F'\t' '$1 ~ /^ii/' > "$TMP/db"

    # The base system the installer marks as manual, like Arch's base group.
    dpkg-query -W -f='${db:Status-Abbrev}\t${Package}\t${Priority}\t${Essential}\n' \
      | awk -F'\t' '$1 ~ /^ii/ && ($3 == "required" || $3 == "important" || $4 == "yes") {print $2}' >> "$TMP/expected"
    ;;
esac

comm -23 <(comm -23 "$TMP/declared_packages" "$TMP/installed_all") \
         "$TMP/declared_groups" > "$TMP/missing"

# Expected also covers everything the expected packages pull in as dependencies,
# all the way down. A dependency that happens to be marked explicit is not real
# drift. Dependencies resolve to an installed package by name or by what it
# provides; on Debian every alternative and Recommends count too, since apt
# installs recommends by default.
python3 - "$TMP" "$DISTRO" <<'PY'
import pathlib, re, sys

tmp, distro = pathlib.Path(sys.argv[1]), sys.argv[2]
deps, owner = {}, {}

def add(name, provides, depends):
    owner[name] = name
    for p in provides:
        owner.setdefault(p, name)
    deps[name] = depends

if distro == "arch":
    strip = lambda d: re.split(r"[<>=]", d, maxsplit=1)[0]
    for block in (tmp / "db").read_text().split("\n\n"):
        fields, key = {}, None
        for line in block.splitlines():
            m = re.match(r"^(\S[^:]*?)\s*: (.*)$", line)
            if m:
                key = m.group(1)
                fields[key] = m.group(2)
            elif key:
                fields[key] += " " + line.strip()
        if "Name" in fields:
            add(fields["Name"],
                [strip(p) for p in fields.get("Provides", "None").split() if p != "None"],
                [strip(d) for d in fields.get("Depends On", "None").split() if d != "None"])
else:
    names = lambda field: [re.sub(r"\s*\(.*?\)|:\w+$", "", n).strip()
                           for n in re.split(r"[,|]", field) if n.strip()]
    for line in (tmp / "db").read_text().splitlines():
        _, name, provides, depends = line.split("\t")
        add(name, names(provides), names(depends))

seen = set()
stack = [n for n in (tmp / "expected").read_text().split() if n in deps]
while stack:
    name = stack.pop()
    if name in seen:
        continue
    seen.add(name)
    stack.extend(owner[d] for d in deps[name] if d in owner)

with open(tmp / "expected", "a") as f:
    f.write("".join(f"{n}\n" for n in sorted(seen)))
PY
sort -u -o "$TMP/expected" "$TMP/expected"

comm -23 "$TMP/installed" "$TMP/expected" > "$TMP/undeclared"

status=0
report() { # label, file
  [[ -s $2 ]] || return 0
  echo "$1 ($(wc -l < "$2")):"
  sed 's/^/  /' "$2"
  echo
  status=1
}

echo "HOST: $HOST ($DISTRO, desktop sessions: $(cat "$TMP/sessions"))"
echo

report "UNDECLARED — installed by hand, not in any role" "$TMP/undeclared"
report "MISSING — declared by a role, not installed" "$TMP/missing"

# Other package managers. Both directions, so something installed outside the
# playbook shows up the same way an undeclared package does.
if command -v flatpak >/dev/null; then
  flatpak list --app --columns=application 2>/dev/null | sort > "$TMP/have_flatpak" || : > "$TMP/have_flatpak"
  comm -23 "$TMP/declared_flatpaks" "$TMP/have_flatpak" > "$TMP/missing_flatpak"
  comm -13 "$TMP/declared_flatpaks" "$TMP/have_flatpak" > "$TMP/undeclared_flatpak"
  report "UNDECLARED FLATPAKS — installed by hand, not in any role" "$TMP/undeclared_flatpak"
  report "MISSING FLATPAKS — declared by a role, not installed" "$TMP/missing_flatpak"
fi

if [[ ${1:-} == --prune ]]; then
  case "$DISTRO" in
    arch)
      mapfile -t orphans < <(pacman -Qdtq 2>/dev/null || true)
      prune_hint='sudo pacman -Rns $(pacman -Qdtq)'
      ;;
    debian)
      mapfile -t orphans < <(apt-get -s autoremove 2>/dev/null | awk '/^Remv /{print $2}')
      prune_hint='doas apt-get autoremove --purge'
      ;;
  esac
  if (( ${#orphans[@]} )); then
    echo "ORPHANS — no longer required by anything (${#orphans[@]}):"
    printf '  %s\n' "${orphans[@]}"
    echo "  remove with: $prune_hint"
    echo
  fi
fi

if [[ ${1:-} == --purge ]]; then
  purge_packages=(); purge_flatpak=()
  mapfile -t purge_packages < "$TMP/undeclared"
  if command -v flatpak >/dev/null && [[ -f "$TMP/undeclared_flatpak" ]]; then
    mapfile -t purge_flatpak < "$TMP/undeclared_flatpak"
  fi

  total=$(( ${#purge_packages[@]} + ${#purge_flatpak[@]} ))
  if (( total == 0 )); then
    echo "Nothing to purge — no undeclared packages."
    exit 0
  fi

  echo "Purging ${total} undeclared package(s):"

  if (( ${#purge_packages[@]} )); then
    printf '  %s: %s %s\n' "$DISTRO" "${REMOVE[*]}" "${purge_packages[*]}"
  fi
  if (( ${#purge_flatpak[@]} )); then
    printf '  flatpak: flatpak uninstall -y %s\n' "${purge_flatpak[*]}"
  fi

  read -r -p "Run these commands? [y/N] " -n 1 answer
  echo
  if [[ ${answer,,} != y ]]; then
    echo "Aborted."
    exit 0
  fi

  if (( ${#purge_flatpak[@]} )); then
    flatpak uninstall -y "${purge_flatpak[@]}"
  fi
  if (( ${#purge_packages[@]} )); then
    "${REMOVE[@]}" "${purge_packages[@]}"
  fi
fi

(( status == 0 )) && echo "In sync: $(wc -l < "$TMP/declared_packages") declared packages, no drift."
exit "$status"
