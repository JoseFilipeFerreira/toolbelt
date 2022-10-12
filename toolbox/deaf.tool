#!/bin/bash
# volume changer

get_percent(){
    mute_status="$(pactl get-sink-mute @DEFAULT_SINK@)"
    if [[ "$mute_status" =~ yes$ ]]; then
        echo "MUTE"
    else
        percent="$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo "[0-9]+%" | head -n1)"
        echo "${percent}%"
    fi
}

case "$1" in
    +|UP)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    -|DOWN)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute|LEFT)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    mic*)
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        ;;

    --subscribe)
        get_percent

        pactl subscribe | grep --line-buffered "sink" |
        while read -r; do
            get_percent
        done
        ;;
    --info)
        get_percent
        ;;

    *)
        echo "USAGE: deaf [+|-|mute|mic|--subscribe|--info]"
        exit
        ;;
esac
