#!/usr/bin/env bash

songs() {
    song=$(mpc listall --format '%artist% - %title%\t%file%' | \
        awk -F'\t' '{print $1}' | \
        fuzzel --dmenu -p "song: ")
    [ -n "$song" ] && {
        file=$(mpc listall --format '%artist% - %title%\t%file%' | \
            awk -F'\t' -v s="$song" '$1==s{print $2}')
        mpc clear && mpc add "$file" && mpc play
    }
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
