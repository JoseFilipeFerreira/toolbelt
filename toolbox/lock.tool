#!/bin/bash
tmpfile="$(mktemp --suffix=.png)"
cuffs "$tmpfile"
convert "$tmpfile" -scale 10% -scale 1000% "$tmpfile"
i3lock \
    --image="$tmpfile" \
    --ignore-empty-password
rm "$tmpfile"
