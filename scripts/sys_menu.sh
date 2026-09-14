#!/usr/bin/env bash
# System menu: pick with 1, 2, 3...

menu() {
    fuzzel --dmenu --auto-select --no-sort -p "$1"
}

# Number of the picked entry ("2  ..." -> 2)
num() {
    awk '{print $1}' <<< "$1"
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
    choice=$(printf '1    power-saver\n2    balanced\n3    performance\n' \
        | sed "s/  $current$/  $current (current)/" | menu "profile: ")
    case $(num "$choice") in
        1) profile=power-saver ;;
        2) profile=balanced ;;
        3) profile=performance ;;
        *) return ;;
    esac
    powerprofilesctl set "$profile" && notify-send "Power profile" "$profile"
}

power_menu() {
    choice=$(printf '1    Lock\n2    Suspend\n3    Log out\n4    Reboot\n5    Shut down\n' | menu "power: ")
    case $(num "$choice") in
        1) swaylock -f -c 000000 ;;
        2) systemctl suspend ;;
        3) swaymsg exit ;;
        4) systemctl reboot ;;
        5) systemctl poweroff ;;
    esac
}

kill_process() {
    choice=$(ps -axo pid=,comm= | sort -k2 | fuzzel --dmenu -p "kill: ")
    [ -n "$choice" ] || return
    read -r pid name <<< "$choice"
    confirm=$(printf '1  No\n2  Yes\n' | menu "kill $name ($pid)? ")
    [ "$(num "$confirm")" = 2 ] || return
    if kill -9 "$pid" 2>/dev/null; then
        notify-send "Killed" "$name ($pid)"
    else
        notify-send -u critical "Kill failed" "$name ($pid)"
    fi
}

choice=$(printf '1    Pass Store\n2    Power Profile\n3    Power Menu\n4  󰓾  Kill Process\n' | menu "system: ")
case $(num "$choice") in
    1) pass_store ;;
    2) power_profile ;;
    3) power_menu ;;
    4) kill_process ;;
esac
