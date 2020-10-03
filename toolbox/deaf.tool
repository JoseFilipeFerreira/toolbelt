#!/bin/bash
case "$1" in
    +)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        pkill -SIGRTMIN+2 thonkbar
        ;;
    -)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        pkill -SIGRTMIN+2 thonkbar
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        pkill -SIGRTMIN+2 thonkbar
        ;;

    --block)
        PACTL=$(pactl list sinks |
            grep --after-context 10 "^[[:space:]]State: RUNNING")

        [ -z "$PACTL" ] && PACTL=$(pactl list sinks |
            grep --after-context 12 "^Sink #")

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
