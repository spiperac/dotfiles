#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ansible refuses to start under a locale that is not generated yet.
# C.UTF-8 is built into glibc and always available.
export LC_ALL=C.UTF-8 LANG=C.UTF-8

source /etc/os-release

# Check every atom referenced by the Gentoo role vars against the
# emerge tree, to catch typos before a full play run.
case "${1:-}" in
    verify|--verify)
        if [ "$ID" != "gentoo" ]; then
        echo "verify is only supported on Gentoo." >&2
        exit 1
    fi
    "$REPO_DIR/scripts/verify_atoms.py"
    exit "$?"
    ;;
esac

case "$ID" in
    debian)
        command -v ansible >/dev/null 2>&1 || { doas apt-get update && doas apt-get install -y ansible git stow; }
        ;;
    arch)
        command -v ansible >/dev/null 2>&1 || sudo pacman -Syu --noconfirm ansible-core git stow
        ;;
    gentoo)
        command -v ansible >/dev/null 2>&1 || doas emerge -av app-admin/ansible-core app-admin/stow
        ;;
    *)
        echo "This bootstrap targets Arch Linux, Gentoo or Debian." >&2
        exit 1
        ;;
esac

# Gentoo and Debian use doas with a nopass rule; ansible drops the doas -n
# flag whenever a become password is set, so -K must not be passed there.
# sudo on Arch needs -K.
case "$ID" in
    gentoo|debian)
        BECOME_ARGS=(-e ansible_become_method=doas)
        ;;
    *)
        BECOME_ARGS=(-K)
        ;;
esac

# Each machine provisions itself: run the play only for the inventory entry
# matching this hostname (see ansible/inventory.ini and ansible/host_vars/).
# DOTFILES_HOST overrides it, e.g. on a fresh install before the hostname is set.
HOST="${DOTFILES_HOST:-$(uname -n)}"
HOST="${HOST%%.*}"

cd "$REPO_DIR/ansible"
if ! ansible-inventory --host "$HOST" >/dev/null 2>&1; then
    echo "Host '$HOST' is not in ansible/inventory.ini." >&2
    exit 1
fi
ansible-galaxy collection install -r requirements.yml
exec ansible-playbook site.yml --limit "$HOST" "${BECOME_ARGS[@]}" "$@"

