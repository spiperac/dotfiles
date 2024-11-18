#!/bin/bash
LOCATION="Novi+Sad"
WEATHER=$(curl -s "https://wttr.in/$LOCATION?format=%c%t")

if [ -z "$WEATHER" ]; then
    echo "N/A"
else
    echo "$WEATHER"
fi
