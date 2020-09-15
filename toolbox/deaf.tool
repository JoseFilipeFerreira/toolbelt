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

    --block)
        PACTL=$(pactl list sinks | \
            grep --after-context 10 "^[[:space:]]State: RUNNING")

        VOLUME=$(echo "$PACTL" | grep -Eo "[0-9]+\%" | head -n1)

        MUTE_STATUS=$(echo "$PACTL" | grep "Mute" | cut -d' ' -f2)

        if [[ $MUTE_STATUS = yes ]]; then
            echo "MUTE"
            echo "MUTE"
        else
            echo "$VOLUME"
            echo "$VOLUME"
        fi
        ;;

    *)
        echo "USAGE: volume [+|-|mute|--block]"
        exit
        ;;
esac

pkill -RTMIN+1 i3blocks
