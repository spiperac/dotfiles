#!/bin/bash

## Update and isntall packages
sudo apt update
sudo apt install curl git cmake python3 -y
sudo apt install i3 i3lock polybar rofi feh -y
sudo apt install python3 python3-pip
sudo apt install zsh -y
sudo apt install neovim nodejs -y

## Setup fonts
FONTS_DIR="/home/spiperac/.local/share/fonts"
mkdir -p $FONTS_DIR
cp -R ./fonts/Hack/ $FONTS_DIR
fc-cache -fv
exit

## i3 Installation
ln -rs i3 ~/.config/i3

### Rust and Python setup\

# Python
pip install pylint black flake8

# Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
rustup component add rust-analyzer

## nvim Setup
ln -rs nvim ~/.config/nvim

## ZSH Setup
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -s zshrc ~/.zshrc
	

