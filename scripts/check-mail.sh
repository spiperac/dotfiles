#!/bin/sh
CACHE="/tmp/.mail_cache"
AGE=300  # refresh every 5 min

if [ -f "$CACHE" ] && [ $(( $(date +%s) - $(date -r "$CACHE" +%s) )) -lt $AGE ]; then
    cat "$CACHE"
    exit 0
fi

count=$(ls -1 ~/Mail/gmail/INBOX/new 2>/dev/null | wc -l | xargs)
echo "$count" | tee "$CACHE"
