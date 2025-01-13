#!/bin/sh

rofi_command="rofi -theme ~/.config/i3/rofi/launcher.rasi"

# Options
shutdown="  Shutdown"
reboot="  Restart"
lock="  Lock"
logout="  Logout"

# Confirmation
confirm_exit() {
    rofi -dmenu -i -no-fixed-num-lines -p "Are you sure? (yes/no)" -theme ~/.config/i3/rofi/launcher.rasi
}

# Variable passed to Rofi
options="$lock\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme ~/.config/i3/rofi/launcher.rasi)"
case $chosen in
    $lock)
        i3lock # Replace with your lock screen command
        ;;
    $logout)
        confirm_exit && pkill -KILL -u $USER
        ;;
    $reboot)
        confirm_exit && /sbin/reboot
        ;;
    $shutdown)
        confirm_exit && /sbin/shutdown -p now
        ;;
esac
