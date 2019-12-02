#!/bin/bash
cd $DOTFILES/dmenu

./"$(find . | grep -v 'menu' | grep '\.dm' | sed -e 's|./||g' -e 's/\.dm$//g' | sort -r | dmenu -i -p "Pick a menu:")".dm &
diswon
