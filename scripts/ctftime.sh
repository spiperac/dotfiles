#!/bin/sh
# deps: curl jq

NOW=$(date +%s)
WEEK=$((NOW + 7 * 86400))

curl -s \
  -H "User-Agent: Mozilla/5.0" \
  "https://ctftime.org/api/v1/events/?limit=100&start=${NOW}&finish=${WEEK}" \
| jq -r '
  ["NAME", "START", "DURATION", "URL"],
  ["────────────────────────────", "───────────────────", "────────", "──────────────────────────────"],
  (.[] | [
    .title,
    (.start | .[0:16] | gsub("T"; " ")),
    ( ( (.finish | .[0:19] | strptime("%Y-%m-%dT%H:%M:%S") | mktime)
      - (.start  | .[0:19] | strptime("%Y-%m-%dT%H:%M:%S") | mktime)
      ) / 3600
      | if . >= 24 then "\(. / 24 | floor)d \(. % 24 | floor)h" else "\(floor)h" end
    ),
    .url
  ])
  | @tsv' \
| column -t -s $'\t'
