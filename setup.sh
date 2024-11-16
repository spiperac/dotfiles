#!/bin/bash

sudo apt update
sudo apt install curl git cmake python3

# i3 Installation
sudo apt install i3 i3lock i3status rofi dmenu
cp -R i3 ~/.config/

# Vim Installation
sudo apt install neovim
cp -R nvim ~/.config/

# ZSH Installation
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp zshrc ~/.zshrc
	

