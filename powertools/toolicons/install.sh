#!/bin/bash
if [ "$1" = check ]; then
    [ -d /usr/share/icons/toolicons ] && exit 0
    exit 1
else
    add-icons
fi
