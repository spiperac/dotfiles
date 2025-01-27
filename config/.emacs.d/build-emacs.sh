#!/bin/bash

sudo dnf install libtree-sitter libtree-sitter-devel libgccjit-devel gtk4-devel webkit2gtk3-devel webkitgtk4 ImageMagick-devel libotf libtree-sitter-java wayland-devel wayland-protocols-devel gcc gcc-c++ make autoconf automake texinfo ncurses-devel gtk3-devel libXpm-devel giflib-devel libjpeg-devel libpng-devel libtiff-devel libXaw-devel gpm-devel dbus-devel systemd-devel libselinux-devel libxml2-devel jansson-devel gnutls-devel harfbuzz-devel

git clone --branch emacs-30 https://git.savannah.gnu.org/git/emacs.git

cd emacs/

./autogen.sh
./configure --with-pgtk --with-mailutils --with-native-compilation --with-imagemagick --with-tree-sitter --with-gnutls --with-modules --with-wide-int --with-rsvg --with-xml2
make -j$(nproc)
sudo make install

