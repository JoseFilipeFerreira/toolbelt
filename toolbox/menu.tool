#!/bin/bash
cd "$DOTFILES/powertools/dmenu" || exit 1

./"$( \
    find . |
    grep '\.menu' |
    sed -e 's|./||g' -e 's/\.menu$//g' |
    sort |
    dmenu -i -p "Pick a menu:")".menu &
diswon
