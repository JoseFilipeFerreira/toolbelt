#!/bin/bash
# menu launcher

scripts=~/.config/menu/scripts

"$scripts"/"$( \
    find "$scripts" -type f -printf "%f\n" |
    grep '\.menu' |
    sed -e 's|./||g' -e 's/\.menu$//g' |
    sort |
    picker -i -l 20 -p "Pick a menu:")".menu &
disown
