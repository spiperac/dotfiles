#!/bin/bash

# Variables
REPO_DIR="$(pwd)" # Get the current directory (where setup.sh is run from)
FONT_DIR="$HOME/.local/share/fonts"
FONTS_SOURCE_DIR="$REPO_DIR/fonts/Hack"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN_DIR="$HOME/.local/bin"

# Dependency lists
APT_DEPENDENCIES=(
    curl git cmake python3 i3 i3lock rofi feh
    pulseaudio-utils alacritty polybar zsh neovim nodejs
    dunst adwaita-icon-theme npm
)

PACMAN_DEPENDENCIES=(
    curl git cmake python i3 i3lock rofi feh
    pulseaudio alacritty polybar zsh neovim nodejs
)

PYTHON_TOOLS=(
    pylint black flake8
)


# Create relative symlinks
create_symlink() {
    local target=$1
    local link_name=$2
    rm -rf "$HOME/$link_name"  # Remove existing files or symlinks
    ln -rs "$target" "$HOME/$link_name"
    echo "Created relative symlink: $link_name -> $target"
}

# Install packages based on the package manager
install_packages() {
    if command -v apt-get &> /dev/null; then
        echo "Installing dependencies for APT..."
        sudo apt-get update
        sudo apt-get install -y "${APT_DEPENDENCIES[@]}"
    elif command -v pacman &> /dev/null; then
        echo "Installing dependencies for Pacman..."
        sudo pacman -Syu --noconfirm "${PACMAN_DEPENDENCIES[@]}"
    else
        echo "Unsupported package manager. Please install packages manually."
        exit 1
    fi
}

# Install Python tools
install_python_tools() {
    echo "Installing Python tools..."
    pip3 install --user --break-system-packages "${PYTHON_TOOLS[@]}" 
    echo "Python tools installed: ${PYTHON_TOOLS[*]}"
}

# Setup fonts
setup_fonts() {
    mkdir -p "$FONT_DIR"
    cp -R "$FONTS_SOURCE_DIR/." "$FONT_DIR/"
    fc-cache -fv
    echo "Fonts installed and cache updated."
}

# Setup i3 and related configurations
setup_i3() {
    mkdir -p "$CONFIG_DIR"
    create_symlink "$REPO_DIR/config/i3" ".config/i3"
    create_symlink "$REPO_DIR/config/polybar" ".config/polybar"
    mkdir -p "$LOCAL_BIN_DIR"
    create_symlink "$REPO_DIR/scripts/chrome.sh" ".local/bin/chrome"
}

# Setup Dunst for notifications
setup_dunst() {
    create_symlink "$REPO_DIR/config/dunst" ".config/dunst"
}

# Setup terminal (Alacritty)
setup_terminal() {
    create_symlink "$REPO_DIR/config/alacritty" ".config/alacritty"
}

# Setup Rust environment
setup_rust_env() {
    echo "Installing Rust..."
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    rustup component add rust-analyzer
    echo "Rust and rust-analyzer installed."
}

setup_nvim() {
    echo "Setting up Neovim..."
    create_symlink "$REPO_DIR/config/nvim" ".config/nvim"

    echo "Installing Neovim plugins using Lazy.nvim..."
    if nvim --headless +Lazy! +qall; then
        echo "Neovim plugins installed successfully."
    else
        echo "Failed to install Neovim plugins. Check your Lazy.nvim configuration."
    fi

    echo "Installing CoC extensions..."
    if [ -f "$HOME/.config/nvim/coc-settings.json" ]; then
        if extensions=$(jq -r '.["coc.global_extensions"][]' "$HOME/.config/nvim/coc-settings.json" 2>/dev/null); then
            if [ -n "$extensions" ]; then
                echo "$extensions" | xargs -n 1 nvim --headless +'CocInstall -sync' +qall
                echo "CoC extensions installed."
            else
                echo "No CoC extensions defined in coc-settings.json."
            fi
        else
            echo "Error parsing coc-settings.json. Ensure it contains valid JSON and includes coc.global_extensions."
        fi
    else
        echo "coc-settings.json not found. Skipping CoC extensions installation."
    fi

    echo "Neovim setup completed."
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
    create_symlink "$REPO_DIR/zshrc" ".zshrc"
}

# Main script execution
main() {
    install_packages
    install_python_tools
    setup_fonts
    setup_i3
    setup_dunst
    setup_terminal
    setup_rust_env
    setup_nvim
    setup_zsh
    echo "Setup completed successfully."
}

main
