#!/data/data/com.termux/files/usr/bin/bash
# change phone wallpaper

tmp=~/.temp_wallpaper.png

magick \
    "$(find ~/.local/share/wallpapers -type f | shuf -n 1)" \
    -gravity center \
    -extent 6:13 \
    "$tmp"

termux-wallpaper -f "$tmp"
rm "$tmp"
