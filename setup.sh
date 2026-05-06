#!/usr/bin/env bash

REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN_DIR="$HOME/.local/bin"

fresh_install() {
    if [ -n "$1" ] && [ "$1" = "fresh" ]; then
        echo "Argument: $1"
        exit
    fi
}

detect_wsl() {
    grep -qEi "microsoft|wsl" /proc/version 2>/dev/null
}

install_packages() {
    if command -v apt-get &> /dev/null; then
        echo "Installing dependencies for APT..."
        sudo apt-get update
        sudo apt-get install -y ansible
    elif command -v dnf &> /dev/null; then
        echo "Installing dependencies for DNF..."
        sudo dnf install -y ansible
        sudo dnf install -y stow
    elif command -v pkg &> /dev/null; then
        echo "Installing dependencies for FreeBSD..."
        sudo pkg install -y stow py311-ansible
    else
        echo "Unsupported package manager. Please install packages manually."
        exit 1
    fi
}

run_ansible() {
    if detect_wsl; then
        echo "WSL detected — running WSL playbook"
        ansible-playbook ansible/wsl-setup.yml -K -vvv
    else
        echo "Running FreeBSD playbook"
        # ansible-playbook ansible/freebsd-setup.yml --ask-become-pass
    fi
}

link_scripts() {
    ln -sf "$REPO_DIR/scripts/" ~/scripts
}

fresh_install "$1"
install_packages
run_ansible
link_scripts
stow config --adopt
echo "Setup completed successfully."
