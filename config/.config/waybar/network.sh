#!/bin/sh
IFACE=$(route -n get default | grep interface | awk '{print $2}')
IP=$(ifconfig $IFACE | grep 'inet ' | awk '{print $2}')
if [ -z "$IP" ]; then
    echo '{"text": "disconnected", "tooltip": "Disconnected"}'
else
    echo "{\"text\": \"$IFACE\", \"tooltip\": \"$IP\"}"
fi
