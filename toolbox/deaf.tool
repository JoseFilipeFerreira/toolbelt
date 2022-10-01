#!/bin/bash
# volume changer (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))

case "$1" in
    +)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        pkill --signal 37 thonkbar
        ;;
    -)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        pkill --signal 37 thonkbar
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        pkill --signal 37 thonkbar
        ;;
    mic*)
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        pkill --signal 37 thonkbar
        ;;

    --info|--block)
        mute_status="$(pactl get-sink-mute @DEFAULT_SINK@)"
        if [[ "$mute_status" =~ yes$ ]]; then
            echo "MUTE"
        else
            pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo "[0-9]+%" | head -n1
        fi
        ;;

    *)
        echo "USAGE: deaf [+|-|mute|mic|--block|--info]"
        exit
        ;;
esac
