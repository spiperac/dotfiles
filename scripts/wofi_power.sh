#!/usr/bin/env bash

CHOICE=$(echo -e "Shutdown\nReboot\nCancel" | wofi --show=dmenu --gtk-dark --prompt="Power:")

case "$CHOICE" in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Cancel|*)
        exit 0
        ;;
esac
