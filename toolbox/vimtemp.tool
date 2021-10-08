#!/bin/bash
# open your `$EDITOR` and copy to clipboard on save&exit

tmp="$(mktemp)"
touch "$tmp"
"$EDITOR" "$tmp"
echo "$tmp"
xclip -selection clipboard "$tmp"
