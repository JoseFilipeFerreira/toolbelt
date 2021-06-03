#!/bin/bash
# brightness changer (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))

n_step="9"
step_percent="$(( 100 / n_step ))"

case "$1" in
    +)
        brightnessctl set +"$step_percent"%
        pkill --signal 36 thonkbar
        ;;
    -)
        brightnessctl --min-value=6 set "$step_percent"-%
        pkill --signal 36 thonkbar
        ;;
    --block)
        xrandr |
            awk '/ connected/ && /[[:digit:]]x[[:digit:]].*+/{print $1}' |
            grep -q "eDP-1" \
        || exit

        curr_percent="$(brightnessctl -m info | grep -Po "[0-9]*(?=%)")"
        echo "$(( curr_percent / step_percent ))"
        ;;
    *)
        echo "USAGE: blind [+|-|--block]"
        exit
        ;;
esac
