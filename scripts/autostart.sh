#!/bin/sh

gnome-keyring-daemon --start --components=secrets &
mako &

case "$(uname -s)" in
    Linux)
        waybar &
        nm-applet --indicator &
        blueman-applet &
        udiskie --tray &
        /usr/libexec/polkit-mate-authentication-agent-1 &
        ;;
    FreeBSD)
        waybar -c ~/.config/waybar/config-freebsd.jsonc &
        wpa_gui -t &
        /usr/local/libexec/polkit-mate-authentication-agent-1 &
        ;;
esac
