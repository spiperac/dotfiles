#!/usr/bin/env bash

# Variables
REPO_DIR="$(pwd)" # Get the current directory (where setup.sh is run from)
CONFIG_DIR="$HOME/.config"
LOCAL_BIN_DIR="$HOME/.local/bin"


fresh_install() {
    if [ -n "$1" ] && [ "$1" = "fresh" ]; then
        echo "Argument: $1"
        exit
    fi
}


# Install packages based on the package manager
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
          sudo pkg install -y ansible
    else
        echo "Unsupported package manager. Please install packages manually."
        exit 1
    fi
}

# Run ansible playbooks
run_ansible() {
  echo "Running ansible"
  ansible-playbook ansible/setup.yml --ask-become
}

link_scripts() {
  ln -sf "$REPO_DIR/scripts/" ~/scripts
}

# Main script execution

fresh_install "$1"
install_packages
run_ansible
link_scripts

stow config --adopt
echo "Setup completed successfully."

