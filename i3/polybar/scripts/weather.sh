#!/bin/bash
LOCATION="Novi+Sad"
WEATHER=$(curl -s "https://wttr.in/$LOCATION?format=1")

if [ -z "$WEATHER" ]; then
    echo "N/A"
else
    echo "$WEATHER"
fi
