#!/bin/bash
BACKLIGHT="/sys/class/backlight/intel_backlight/brightness"

CURR="$(cat "$BACKLIGHT")"

[ "$(stat --format '%U' "$BACKLIGHT")" = "$USER" ] || \
    sudo chown "$USER":"$USER" "$BACKLIGHT"

case "$1" in
    +)
        echo "$(( CURR + 40 ))" > "$BACKLIGHT"
        ;;
    -)
        echo "$(( CURR - 40 ))" > "$BACKLIGHT"
        ;;
    curr)
        echo "$CURR"
        ;;
    *)
        echo "USAGE: blind [+|-|curr]"
        ;;
esac
