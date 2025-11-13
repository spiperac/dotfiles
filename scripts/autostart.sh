#!/usr/bin/env bash

# Kill already running dublicate process
_ps="waybar mako swaybg nm-applet pasystray"
for _prs in $_ps; do
    if [ "$(pidof "${_prs}")" ]; then
         killall -9 "${_prs}"
    fi
done

swaybg --output "*" --mode fill -i "~/.config/assets/wallpaper.png" &
waybar &
nm-applet &
mako &
pasystray &
foot --server &

exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
