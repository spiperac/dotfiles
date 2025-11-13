# Dotfiles

This repository contains my personal configuration files and scripts to set up my Linux development environment.

## Features

- **Neovim Configuration**:
  - Automatic plugin installation with native pkg manager.
  - vim.pack.add and vim.pack.update.
- **Terminal**:
  - Configuration for foot.
- **Development Tools**:
  - Golang
  - Rust
  - PHP
  - Clang
  - Preconfigured Python tools (`black`, `pylint`, `flake8`) and Rust with `rust-analyzer`.
- **Text editors**:
    - Neovim ( nightly)
    - Emacs

## Requirements

- **Package Manager**: 
  - DNF supported.
- **Ansible**
- **Bash**


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
   - Setup tmux and zsh.

4. Log out and log back in if the default shell is changed to Zsh.

## Notes

- These are my personal configuration files and are not intended for general use.
- Existing dotfiles in the home directory will be replaced during setup.
