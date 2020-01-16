#!/bin/bash
cd $POWERTOOLS/dmenu

./"$(find . | grep '\.menu' | sed -e 's|./||g' -e 's/\.menu$//g' | sort -r | dmenu -i -p "Pick a menu:")".menu &
diswon
