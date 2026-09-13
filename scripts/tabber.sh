#!/usr/bin/env bash
# Alt-tab style window switcher for sway, with app icons

app_dirs=(
    "$HOME/.local/share/applications"
    "$HOME/.local/share/flatpak/exports/share/applications"
    /var/lib/flatpak/exports/share/applications
    /usr/share/applications
)

# Find the desktop entry for an app_id / X11 class
desktop_file_for() {
    local app=$1 file dir
    file=$(grep -rlixsF --include='*.desktop' "StartupWMClass=$app" "${app_dirs[@]}" | head -1)
    if [ -z "$file" ]; then
        for dir in "${app_dirs[@]}"; do
            [ -f "$dir/$app.desktop" ] && file="$dir/$app.desktop" && break
        done
    fi
    echo "$file"
}

# id, workspace, app, title, focused; unit-separated, focused window sorted last
windows=$(swaymsg -t get_tree | jq -r '
    recurse(.nodes[]?, .floating_nodes[]?)
    | select(.type == "workspace") | . as $ws
    | recurse(.nodes[]?, .floating_nodes[]?)
    | select(.pid?)
    | (.app_id // .window_properties.class // "unknown") as $app
    | [(.id | tostring),
       ($ws.name | sub("__i3_scratch"; "scratch")),
       $app,
       ((.name // "") | gsub("[\t\n]"; " ") | gsub("^ +| +$"; "") | if . == "" then $app else . end),
       (.focused | tostring)]
    | join("\u001f")' | sort -s -t $'\x1f' -k5,5)

[ -z "$windows" ] && exit 0

idx=$(while IFS=$'\x1f' read -r _ ws app title _; do
          file=$(desktop_file_for "$app")
          icon= name=
          if [ -n "$file" ]; then
              icon=$(sed -n 's/^Icon=//p' "$file" | head -1)
              name=$(sed -n 's/^Name=//p' "$file" | head -1)
          fi
          [ "$title" = "$app" ] && title=${name:-$app}
          printf '%s  %s\0icon\x1f%s\n' "$ws" "$title" "${icon:+$icon,}$app,${app,,},application-x-executable"
      done <<< "$windows" | fuzzel --dmenu --index --no-sort -p "window: ")

[ -n "$idx" ] && [ "$idx" -ge 0 ] || exit 0

id=$(sed -n "$((idx + 1))p" <<< "$windows" | cut -d $'\x1f' -f1)
swaymsg "[con_id=$id] focus" >/dev/null
