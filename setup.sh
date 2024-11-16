#!/bin/bash

sudo apt update
sudo apt install curl git cmake python3 -y

# i3 Installation
sudo apt install i3 i3lock i3status rofi dmenu -y
cp -R i3 ~/.config/

# Vim Installation
sudo apt install neovim nodejs -y
cp -R nvim ~/.config/

# ZSH Installation
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp zshrc ~/.zshrc
	

