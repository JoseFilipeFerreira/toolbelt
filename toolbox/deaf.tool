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

    --block)
        pactl=$(\
            pactl list sinks |
            grep --after-context 10 "^[[:space:]]State: RUNNING")

        [[ ! "$pactl" ]] && \
            pactl=$(pactl list sinks | grep --after-context 12 "^Sink #")

        volume=$(echo "$pactl" | grep -Eo "[0-9]+\%" | head -n1)

        mute_status=$(echo "$pactl" | grep "Mute" | cut -d' ' -f2)

        if [[ $mute_status = yes ]]; then
            echo "MUTE"
        else
            echo "$volume"
        fi
        ;;

    *)
        echo "USAGE: deaf [+|-|mute|mic|--block]"
        exit
        ;;
esac
