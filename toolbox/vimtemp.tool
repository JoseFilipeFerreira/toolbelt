#!/bin/bash
# open your `$EDITOR` and copy to clipboard on save&exit

tmp="$(mktemp)"

[[ "$1" ]] && tmp="$(mktemp --suffix=".$1")"
touch "$tmp"
"$EDITOR" "$tmp"
echo "$tmp"
xclip -selection clipboard "$tmp"
