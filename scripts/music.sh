#!/usr/bin/env bash

songs() {
    file=$(mpc listall --format '%artist% - %title%\t%file%' | \
        fuzzel --dmenu --with-nth=1 --accept-nth=2 -p "song: ")
    [ -n "$file" ] && mpc clear && mpc add "$file" && mpc play
}

artists() {
    artist=$(mpc list artist | fuzzel --dmenu -p "artist: ")
    [ -n "$artist" ] && mpc clear && mpc find artist "$artist" | mpc add && mpc play
}

albums() {
    album=$(mpc list album | fuzzel --dmenu -p "album: ")
    [ -n "$album" ] && mpc clear && mpc find album "$album" | mpc add && mpc play
}

playlists() {
    playlist=$(mpc lsplaylists | fuzzel --dmenu -p "playlist: ")
    [ -n "$playlist" ] && mpc clear && mpc load "$playlist" && mpc play
}

sync() {
    mpc update
}

choice=$(printf 'songs\nartists\nalbums\nplaylists\nsync' | fuzzel --dmenu -p "music: ")
[ -n "$choice" ] && "$choice"
