#!/bin/bash
# image picker using fzf

folder="$XDG_DATA_HOME/mightymemes"
file="$(find "$folder" -type f -printf '%f\n' | fzf)"
[[ "$file" ]] || exit

case "$file" in
    *.mp4)
        type='video/mp4'
        ;;
    *.gif)
        type='image/gif'
        ;;
    *.png)
        type='image/png'
        ;;
    *.jpg|*.jpeg)
        type='image/jpeg'
        ;;
esac

echo "$type"

[[ "$type" ]] || exit

xclip -i -target "$type" -selection clipboard "$folder/$file"
