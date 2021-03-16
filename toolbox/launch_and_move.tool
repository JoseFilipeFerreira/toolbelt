#!/bin/bash
# move to a workspace and launch a program (if that program is not running)

i3-msg workspace "$1"

if ! pgrep "$2" &>/dev/null
then
        "${@:2}"
fi
