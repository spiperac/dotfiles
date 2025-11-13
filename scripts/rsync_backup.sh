#!/usr/bin/env bash
INCLUDE=(.ssh Vault)
FILES=(.mbsyncrc)
ARGS=()

for dir in "${INCLUDE[@]}"; do
  ARGS+=(--include="$dir/***")
done

for file in "${FILES[@]}"; do
  ARGS+=(--include="$file")
done

SRC="/home/spiperac/"
DST="/mnt/backup/home/spiperac/"

if [[ "$1" == "--pull" ]]; then
  # reverse: restore from backup
  rsync -ruvhP "${DST}" "${SRC}" "${ARGS[@]}" --exclude='*'
else
  # normal backup
  rsync -ruvhP "${SRC}" "${DST}" "${ARGS[@]}" --exclude='*'
fi
