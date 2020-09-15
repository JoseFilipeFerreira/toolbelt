#!/bin/bash
FOLDER="/sys/class/backlight/intel_backlight"

MAX="$(cat "$FOLDER/max_brightness")"

STEP="$(echo "$MAX"/9 | bc)"

BACKLIGHT="$FOLDER/brightness"
CURR="$(cat "$BACKLIGHT")"

[ "$(stat --format '%U' "$BACKLIGHT")" = "$USER" ] || \
    sudo chown "$USER":"$USER" "$BACKLIGHT"

case "$1" in
    +)
        echo "$(( CURR + STEP ))" > "$BACKLIGHT"
        ;;

    -)
        echo "$(( CURR - STEP ))" > "$BACKLIGHT"
        ;;

    --block)
        [ -n "$( \
            xrandr | \
            awk '/ connected/ && /[[:digit:]]x[[:digit:]].*+/{print $1}' | \
            grep "eDP-1")" ] || exit

        CURR_STEP="$(echo "$CURR"/"$STEP" | bc)"

        echo "$CURR_STEP"
        echo "$CURR_STEP"

        case $(echo "$CURR"*5/"$MAX" | bc) in
            0) echo "#424020" ;;

            1) echo "#686538" ;;

            2) echo "#939059" ;;

            3) echo "#BDB881" ;;

            *) echo "#FFFFFF" ;;
        esac
        ;;
    *)
        echo "USAGE: blind [+|-|--block]"
        exit
        ;;
esac

pkill -RTMIN+2 i3blocks
