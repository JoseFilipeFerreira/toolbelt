#!/bin/bash
N_STEP="9"

STEP_PERCENT="$(echo 100/"$N_STEP" | bc)"

case "$1" in
    +)
        brightnessctl set +"$STEP_PERCENT"%
        pkill -SIGRTMIN+1 thonkbar
        ;;

    -)
        brightnessctl --min-value=6 set "$STEP_PERCENT"-%
        pkill -SIGRTMIN+1 thonkbar
        ;;

    --block)
        xrandr | \
            awk '/ connected/ && /[[:digit:]]x[[:digit:]].*+/{print $1}' | \
            grep -q "eDP-1" \
        || exit

        CURR_PERCENT="$(brightnessctl -m info | grep -Po "[0-9]*(?=%)")"

        CURR_STEP="$(echo "$CURR_PERCENT"/"$STEP_PERCENT" | bc)"

        echo "$CURR_STEP"
        echo "$CURR_STEP"

        case $(echo "$CURR_PERCENT/20" | bc) in
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
