#!/bin/sh

IFACE="wlan0"

# Scan for networks
ifconfig $IFACE up
NETWORKS=$(ifconfig $IFACE list scan | tail -n +2 | awk '{print $1}' | sort -u)

# Pick one with fzf
SSID=$(echo "$NETWORKS" | fzf --prompt="Select network: ")

[ -z "$SSID" ] && exit 0

# Check if already in wpa_supplicant.conf
if grep -q "ssid=\"$SSID\"" /etc/wpa_supplicant.conf; then
    echo "Known network, connecting..."
    service netif restart $IFACE
    exit 0
fi

# Ask for password
printf "Password for %s: " "$SSID"
stty -echo
read PASSWORD
stty echo
echo

# Add to wpa_supplicant.conf
wpa_passphrase "$SSID" "$PASSWORD" >> /etc/wpa_supplicant.conf
service netif restart $IFACE
