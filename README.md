# Dotfiles

This repository contains my personal configuration files and scripts to set up my Linux development environment.

## Features

- **Emacs Config:
  - Use package
  - My modules
- **Neovim Configuration**:
  - Plugin management with [Lazy.nvim](https://github.com/folke/lazy.nvim).
  - Automatic plugin installation.
- **Terminal**:
  - Configuration for Alacritty.
- **Sway Window Manager**:
  - Custom keybindings and Waybar and Swaync notification integration.
- **Development Tools**:
  - Preconfigured Python tools (`black`, `pylint`, `flake8`) and Rust with `rust-analyzer`.

## Requirements

- **Package Manager**: 
  - DNF supported.
- **Tools**:
  - Emacs preferably compiled > v30
  - [Neovim](https://neovim.io) (>= 0.5).

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/spiperac/dotfiles.git
   cd dotfiles
   ```

2. Make the setup script executable:
   ```bash
   chmod +x setup.sh
   ```

3. Run the setup script:
   ```bash
   ./setup.sh
   ```

   This will:
   - Install required dependencies.
   - Run *stow* to sort out dot files.
   - Install Emacs and Neovim plugins and CoC extensions.
   - Setup tmux and zsh.
   - Setup Sway, Waybar, Wofi and Swaync.

4. Log out and log back in if the default shell is changed to Zsh.

## Notes

- These are my personal configuration files and are not intended for general use.
- Existing dotfiles in the home directory will be replaced during setup.
