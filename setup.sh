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
    fedora)
        command -v ansible >/dev/null 2>&1 || sudo dnf install -y ansible-core git stow
        ;;
    arch)
        command -v ansible >/dev/null 2>&1 || sudo pacman -Syu --noconfirm ansible-core git stow
        ;;
    gentoo)
        command -v ansible >/dev/null 2>&1 || doas emerge -av app-admin/ansible-core app-admin/stow
        ;;
    *)
        echo "This bootstrap targets Fedora, Arch Linux or Gentoo." >&2
        exit 1
        ;;
esac

# Gentoo uses doas with a nopass rule; ansible drops the doas -n flag
# whenever a become password is set, so -K must not be passed there.
# sudo on every other distribution needs -K.
case "$ID" in
    gentoo)
        BECOME_ARGS=(-e ansible_become_method=doas)
        ;;
    *)
        BECOME_ARGS=(-K)
        ;;
esac

cd "$REPO_DIR/ansible"
ansible-galaxy collection install -r requirements.yml
exec ansible-playbook site.yml "${BECOME_ARGS[@]}" "$@"

