#!/bin/bash
mkdir -p ~/.vim/bundle
apt update && apt install cmake git python3 fonts-powerline curl zsh i3 i3status i3lock
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim


cp vimrc ~/.vimrc
cp zshrc ~/.zshrc
cp -R i3 ~/.config/
vim +PluginInstall
python3 ~/.vim/bundle/YouCompleteMe/install.py
