#!/usr/bin/env bash
DB='/home/spiperac/Vault/Passwords.kdbx'
TIMEOUT=30
MASTER=$(echo -n '' | wmenu -P -p "Master password:")

# pick entry (only list)
ENTRY=$(printf '%s\n' "$MASTER" | keepassxc-cli ls "$DB" "Browser" | wofi --show=dmenu --style="/home/spiperac/.config/wofi/wofi.css" -p "Select password:")

# or copy password to clipboard
#
notify-send "KeePassXC" "Copying password to clipboard..."
printf '%s\n' "$MASTER" | keepassxc-cli  clip "$DB" "Browser/$ENTRY" $TIMEOUT -a password

unset MASTER

