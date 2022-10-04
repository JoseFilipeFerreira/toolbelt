#!/bin/bash
# volume changer

get_percent(){
    mute_status="$(pactl get-sink-mute @DEFAULT_SINK@)"
    if [[ "$mute_status" =~ yes$ ]]; then
        echo "MUTE"
    else
        pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo "[0-9]+%" | head -n1
    fi
}

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
    mic*)
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        ;;

    --subscribe)
        get_percent
        while read -r line; do
            get_percent
        done <  <(pactl subscribe | grep --line-buffered "sink")
        ;;
    --info)
        get_percent
        ;;

    *)
        echo "USAGE: deaf [+|-|mute|mic|--subscribe|--info]"
        exit
        ;;
esac
