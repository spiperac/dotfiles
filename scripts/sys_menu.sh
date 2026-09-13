#!/usr/bin/env bash
# System menu: pick with 1, 2, 3...

menu() {
    fuzzel --dmenu --auto-select --no-sort -p "$1"
}

pass_store() {
    entry=$(cd ~/.password-store && fd -e gpg | sed 's/\.gpg$//' | sort | fuzzel --dmenu -p "pass: ")
    [ -n "$entry" ] || return
    if pass -c "$entry" >/dev/null 2>&1; then
        notify-send "pass" "Copied $entry (clears in 45s)"
    else
        notify-send -u critical "pass" "Failed to decrypt $entry"
    fi
}

power_profile() {
    current=$(powerprofilesctl get)
    choice=$(printf '1  power-saver\n2  balanced\n3  performance\n' \
        | sed "s/  $current$/  $current (current)/" | menu "profile: ")
    [ -n "$choice" ] || return
    profile=$(awk '{print $2}' <<< "$choice")
    powerprofilesctl set "$profile" && notify-send "Power profile" "$profile"
}

power_menu() {
    choice=$(printf '1  Lock\n2  Suspend\n3  Log out\n4  Reboot\n5  Shut down\n' | menu "power: ")
    case "$choice" in
        "1  Lock")      swaylock -f -c 000000 ;;
        "2  Suspend")   systemctl suspend ;;
        "3  Log out")   swaymsg exit ;;
        "4  Reboot")    systemctl reboot ;;
        "5  Shut down") systemctl poweroff ;;
    esac
}

choice=$(printf '1  Pass Store\n2  Power Profile\n3  Power Menu\n' | menu "system: ")
case "$choice" in
    "1  Pass Store")    pass_store ;;
    "2  Power Profile") power_profile ;;
    "3  Power Menu")    power_menu ;;
esac
