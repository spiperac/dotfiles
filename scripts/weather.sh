#!/usr/bin/env bash
CACHE_FILE="/tmp/waybar-wttr.json"
CACHE_TIME=1800

if [ -f "$CACHE_FILE" ]; then
    AGE=$(($(date +%s) - $(date -r "$CACHE_FILE" +%s 2>/dev/null || echo 0)))
    if [ $AGE -lt $CACHE_TIME ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

WEATHER=$(curl -sf "wttr.in/Krusevac?format=j1" 2>/dev/null)

if [ -z "$WEATHER" ]; then
    printf '{"text":"N/A","tooltip":"Unavailable"}\n'
    exit 0
fi

TEMP=$(printf '%s' "$WEATHER" | jq -r '.current_condition[0].temp_C')

if [ -z "$TEMP" ] || [ "$TEMP" = "null" ]; then
    printf '{"text":"N/A","tooltip":"Unavailable"}\n'
    exit 0
fi

CONDITION=$(printf '%s' "$WEATHER" | jq -r '.current_condition[0].weatherDesc[0].value')
FEELS=$(printf '%s' "$WEATHER" | jq -r '.current_condition[0].FeelsLikeC')
HUMIDITY=$(printf '%s' "$WEATHER" | jq -r '.current_condition[0].humidity')
WIND=$(printf '%s' "$WEATHER" | jq -r '.current_condition[0].windspeedKmph')
WIND_DIR=$(printf '%s' "$WEATHER" | jq -r '.current_condition[0].winddir16Point')

case "$CONDITION" in
    *[Cc]lear*|*[Ss]unny*) ICON="☀️" ;;
    *[Pp]artly*|*[Cc]loudy*) ICON="⛅" ;;
    *[Oo]vercast*|*[Cc]loud*) ICON="☁️" ;;
    *[Rr]ain*) ICON="🌧️" ;;
    *[Ss]now*) ICON="❄️" ;;
    *) ICON="🌡️" ;;
esac

TOOLTIP="$CONDITION | Feels like ${FEELS}°C | Humidity: ${HUMIDITY}% | Wind: ${WIND} km/h $WIND_DIR"
OUTPUT="{\"text\":\"$ICON $TEMP°C\",\"tooltip\":\"$TOOLTIP\"}"
echo "$OUTPUT" > "$CACHE_FILE"
echo "$OUTPUT"
