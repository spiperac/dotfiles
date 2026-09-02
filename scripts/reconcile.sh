#!/usr/bin/env bash
# Compare what the Ansible roles declare against what is actually installed.
#
#   ./scripts/reconcile.sh          # report drift
#   ./scripts/reconcile.sh --prune  # also list orphan removal candidates
#
# Two directions of drift:
#   UNDECLARED  installed explicitly, but no role asks for it -> add it to a role
#   MISSING     a role declares it, but it is not installed   -> re-run the playbook
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v pacman >/dev/null || { echo "reconcile.sh currently supports Arch only." >&2; exit 1; }

# Pull the declared names out of the role vars, keyed by what kind of thing they
# are. Only *_packages feed the pacman comparison; pipx/go/flatpak are reported
# separately because they are installed by different managers.
python3 - "$REPO_DIR" "$TMP" <<'PY'
import pathlib, sys, yaml

repo, tmp = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
buckets = {"packages": set(), "flatpaks": set(), "pipx": set(), "go": set()}

for f in sorted((repo / "ansible" / "roles").glob("*/vars/arch.yaml")):
    for key, val in (yaml.safe_load(f.read_text()) or {}).items():
        if not isinstance(val, list):
            continue
        for suffix, bucket in (
            ("_packages", "packages"),
            ("_flatpaks", "flatpaks"),
            ("_pipx", "pipx"),
            ("_go", "go"),
        ):
            if key.endswith(suffix):
                buckets[bucket].update(str(v) for v in val)
                break

for name, items in buckets.items():
    (tmp / f"declared_{name}").write_text("".join(f"{i}\n" for i in sorted(items)))
PY

pacman -Qeq | sort > "$TMP/installed"
pacman -Qq  | sort > "$TMP/installed_all"

# Expected = declared + members of any declared group + direct deps of declared
# packages. A dependency that happens to be marked explicit is not real drift.
pacman -Sg 2>/dev/null | sort -u > "$TMP/groups" || : > "$TMP/groups"
comm -12 "$TMP/declared_packages" "$TMP/groups" > "$TMP/declared_groups"

cp "$TMP/declared_packages" "$TMP/expected"
# A group is satisfied when its members are present; the group name itself is
# never an installed package, so it must not count as MISSING.
mapfile -t groups < <(cat "$TMP/declared_groups"; echo base; echo base-devel)
pacman -Sqg "${groups[@]}" 2>/dev/null >> "$TMP/expected" || true

comm -23 <(comm -23 "$TMP/declared_packages" "$TMP/installed_all") \
         "$TMP/declared_groups" > "$TMP/missing"
# Direct dependencies of every declared package that is actually installed, in
# one batched query (pactree per-package is ~100x slower). Version constraints
# and soname provides are stripped; leftovers simply never match a package name.
mapfile -t present < <(comm -12 "$TMP/declared_packages" "$TMP/installed_all")
if (( ${#present[@]} )); then
  pacman -Qi "${present[@]}" 2>/dev/null \
    | awk -F': ' '/^Depends On/ && $2 != "None" {print $2}' \
    | tr ' ' '\n' \
    | sed 's/[<>=].*//' \
    | grep -v '^$' >> "$TMP/expected" || true
fi
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

report "UNDECLARED — installed by hand, not in any role" "$TMP/undeclared"
report "MISSING — declared by a role, not installed" "$TMP/missing"

# Non-pacman managers. Both directions, so something installed outside the
# playbook shows up the same way an undeclared pacman package does.
if command -v flatpak >/dev/null; then
  flatpak list --app --columns=application 2>/dev/null | sort > "$TMP/have_flatpak" || : > "$TMP/have_flatpak"
  comm -23 "$TMP/declared_flatpaks" "$TMP/have_flatpak" > "$TMP/missing_flatpak"
  comm -13 "$TMP/declared_flatpaks" "$TMP/have_flatpak" > "$TMP/undeclared_flatpak"
  report "UNDECLARED FLATPAKS — installed by hand, not in any role" "$TMP/undeclared_flatpak"
  report "MISSING FLATPAKS — declared by a role, not installed" "$TMP/missing_flatpak"
fi

if command -v pipx >/dev/null; then
  pipx list --short 2>/dev/null | awk '{print $1}' | sort > "$TMP/have_pipx" || : > "$TMP/have_pipx"
  comm -23 "$TMP/declared_pipx" "$TMP/have_pipx" > "$TMP/missing_pipx"
  comm -13 "$TMP/declared_pipx" "$TMP/have_pipx" > "$TMP/undeclared_pipx"
  report "UNDECLARED PIPX — installed by hand, not in any role" "$TMP/undeclared_pipx"
  report "MISSING PIPX — declared by a role, not installed" "$TMP/missing_pipx"
fi

if [[ ${1:-} == --prune ]]; then
  mapfile -t orphans < <(pacman -Qdtq 2>/dev/null || true)
  if (( ${#orphans[@]} )); then
    echo "ORPHANS — no longer required by anything (${#orphans[@]}):"
    printf '  %s\n' "${orphans[@]}"
    echo '  remove with: sudo pacman -Rns $(pacman -Qdtq)'
    echo
  fi
fi

(( status == 0 )) && echo "In sync: $(wc -l < "$TMP/declared_packages") declared packages, no drift."
exit "$status"
