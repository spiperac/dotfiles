#!/bin/sh

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
      elif command -v pacman &> /dev/null; then
        echo "Installing dependencies for Pacman..."
        sudo pacman -Syu --noconfirm ansible
      elif command -v dnf &> /dev/null; then
        echo "Installing dependencies for DNF..."
        sudo dnf install -y ansible
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

# Setup Zsh and Oh My Zsh
setup_zsh() {
    echo "Setting up Zsh..."
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        chsh -s "$(command -v zsh)"
        echo "Default shell changed to zsh. Please log out and log back in."
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# Main script execution

fresh_install "$1"
install_packages
run_ansible

stow config
setup_zsh
echo "Setup completed successfully."

