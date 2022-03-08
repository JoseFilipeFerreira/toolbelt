#!/bin/bash
# blured lockscreen

mkdir -p "/tmp/$USER"
file="/tmp/$USER/lock.png"

cuffs "$file"
convert "$file" -scale 10% -scale 1000% "$file"
i3lock \
    --image="$file" \
    --ignore-empty-password
