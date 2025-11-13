#!/usr/bin/env bash
DB='/home/spiperac/Vault/Passwords.kdbx'
TIMEOUT=30
MASTER=$(echo -n '' | wmenu -P -p "Master password:")

OUT=$(printf '%s\n' "$MASTER" | keepassxc-cli ls "$DB" "Browser/Passwords" 2>/dev/null) || { notify-send "KeePassXC" "Invalid master password"; exit 1; }
ENTRY=$(printf '%s\n' "$OUT" | wmenu -l 10 -p "Select password:")
printf '%s\n' "$OUT" | grep -Fxq "$ENTRY" || { notify-send "KeePassXC" "Invalid or cancelled selection"; exit 1; }

notify-send "KeePassXC" "Copying password to clipboard..."
printf '%s\n' "$MASTER" | keepassxc-cli clip "$DB" "Browser/Passwords/$ENTRY" "$TIMEOUT" -a password

unset MASTER

