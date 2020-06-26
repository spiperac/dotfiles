#!/bin/sh

sudo apt install scrot feh -y
sudo add-apt-repository ppa:kgilmer/speed-ricer -y
sudo apt update

sudo apt install i3-gaps -y

ln -s $(pwd) /home/spiperac/.config/i3
ln -s $(pwd)/i3status/ /home/spiperac/.config/i3status
