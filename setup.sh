#!/bin/bash
cp vimrc ~/.vimrc
cp zshrc ~/.zshrc
vim +PluginInstall
python3 ~/.vim/bundle/YouCompleteMe/install.py
