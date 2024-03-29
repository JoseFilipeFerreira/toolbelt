#!/data/data/com.termux/files/usr/bin/bash
# change phone wallpaper

file="$1"
[[ "$file" ]] || file="$(find ~/.local/share/wallpapers -type f | shuf -n 1)"

tmp=~/.temp_wallpaper.png
magick "$file" -gravity center -extent 30:67 "$tmp"
termux-wallpaper -f "$tmp"
termux-toast "$(basename "$file")"
