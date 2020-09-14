#!/bin/bash
case "$1" in
    +)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    -)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    *)
        echo "USAGE: volume [+|-|mute]"
        exit
        ;;
esac

pkill -RTMIN+1 i3blocks
