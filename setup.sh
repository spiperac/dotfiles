#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source /etc/os-release

case "$ID" in
    fedora)
        command -v ansible >/dev/null 2>&1 || sudo dnf install -y ansible git stow
        ;;
    arch)
        command -v ansible >/dev/null 2>&1 || sudo pacman -Syu --noconfirm ansible git stow
        ;;
    *)
        echo "This bootstrap targets Fedora or Arch Linux." >&2
        exit 1
        ;;
esac

cd "$REPO_DIR/ansible"
exec ansible-playbook site.yml -K "$@"

