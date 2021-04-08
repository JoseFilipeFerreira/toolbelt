#!/bin/bash
# brightness changer (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))

n_step="9"
step_percent="$(echo 100/"$n_step" | bc)"

case "$1" in
    +)
        brightnessctl set +"$step_percent"%
        pkill -SIGRTMIN+1 thonkbar
        ;;
    -)
        brightnessctl --min-value=6 set "$step_percent"-%
        pkill -SIGRTMIN+1 thonkbar
        ;;
    --block)
        xrandr |
            awk '/ connected/ && /[[:digit:]]x[[:digit:]].*+/{print $1}' |
            grep -q "eDP-1" \
        || exit

        curr_percent="$(brightnessctl -m info | grep -Po "[0-9]*(?=%)")"
        curr_step="$(echo "$curr_percent"/"$step_percent" | bc)"

        echo "$curr_step"
        case $(echo "$curr_percent/20" | bc) in
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
