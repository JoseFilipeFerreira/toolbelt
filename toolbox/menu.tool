#!/bin/bash
# dmenu menu launcher

scripts=~/.config/dmenu/scripts

"$scripts"/"$( \
    find "$scripts" -type f -printf "%f\n" |
    grep '\.menu' |
    sed -e 's|./||g' -e 's/\.menu$//g' |
    sort |
    dmenu -i -l 20 -p "Pick a menu:")".menu &
disown
