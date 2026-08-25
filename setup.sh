#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -r /etc/os-release ] || ! grep -q '^ID=fedora' /etc/os-release; then
    echo "This bootstrap targets Fedora." >&2
    exit 1
fi

if ! rpm -q ansible >/dev/null 2>&1; then
    sudo dnf install -y ansible git stow
fi

cd "$REPO_DIR/ansible"
exec ansible-playbook site.yml -K "$@"
