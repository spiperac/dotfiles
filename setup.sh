#!/bin/bash

sudo apt update
sudo apt install curl git cmake python3

# i3 Installation
sudo apt install i3 i3lock i3status rofi dmenu
cp -R i3 ~/.config/

# Vim Installation
sudo apt install vim fonts-powerline
cp vimrc ~/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.vim/bundle
# You complete me
cp .ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py
python3 ~/.vim/bundle/YouCompleteMe/install.py
vim +PlugInstall

# ZSH Installation
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp zshrc ~/.zshrc
	

