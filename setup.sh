#!/bin/bash

sudo apt update
sudo apt install curl git cmake python3 -y

## Setup fonts
FONTS_DIR="/home/spiperac/.local/share/fonts"
mkdir -p $FONTS_DIR
cp -R ./fonts/Hack/ $FONTS_DIR
fc-cache -fv
exit

## i3 Installation
sudo apt install i3 i3lock i3status rofi dmenu -y
ln -rs i3 ~/.config/i3

### Rust and Python setup\

# Python
sudo apt install python3 python3-pip
pip install pylint black flake8

# Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
rustup component add rust-analyzer


## nvim Installation
sudo apt install neovim nodejs -y
ln -rs nvim ~/.config/nvim

## ZSH Installation
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -s zshrc ~/.zshrc
	

