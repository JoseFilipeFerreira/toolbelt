#!/bin/bash
# simple bookmark manager

notify(){
    notify-send -u low -i clippy -a clippy "$1" "$2"
}

file=~/.local/share/toolbelt/clippy
mkdir -p "$(dirname "$file")"
touch "$file"

case "$1" in
    --add)
        bookmark="$(xclip -o)"
        if grep -q "^$bookmark$" "$file"; then
            notify "Already Bookmarked"
        else
            notify "Bookmark Added" "$bookmark"
            echo "$bookmark" >> "$file"
        fi
        ;;
    --select)
        xdotool type "$(grep -v '^#' "$file" | dmenu -l 20 -i | cut -d' ' -f1)"
        ;;
esac

