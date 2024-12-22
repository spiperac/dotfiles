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
    dunst adwaita-icon-theme npm redshift redshift-gtk
    pamixer tmux ranger gsimplecal network-manager-gnome
)

APT_HYPR=(
    hyprland hyprpaper hyprlock hypridle wofi waybar 
)

PACMAN_DEPENDENCIES=(
    curl git cmake python python-pip i3 i3lock rofi feh
    alacritty polybar zsh neovim nodejs dunst adwaita-icon-theme
    npm redshift keychain pamixer tmux ranger gsimplecal network-manager-applet
)

PACMAN_HYPR=(
    hyprland hyprpaper hyprlock hypridle hyprshot wofi waybar
)

PYTHON_TOOLS=(
    pylint black flake8 
)

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
        sudo apt-get install -y "${APT_DEPENDENCIES[@]}"
        sudo add-apt-repository ppa:cppiber/hyprland -y
        sudo apt-get install -y "${APT_HYPR[@]}"
    elif command -v pacman &> /dev/null; then
        echo "Installing dependencies for Pacman..."
        sudo pacman -Syu --noconfirm "${PACMAN_DEPENDENCIES[@]}"
        sudo pacman -Syu --noconfirm "${PACMAN_HYPR[@]}"
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
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# Main script execution

fresh_install "$1"
install_packages
install_python_tools
setup_fonts
setup_rust_env

stow config
setup_zsh
echo "Setup completed successfully."

