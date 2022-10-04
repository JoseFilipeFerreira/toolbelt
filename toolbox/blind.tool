#!/bin/bash
# brightness changer for backlight and keyboard (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))

usage(){

    echo "NAME:"
    echo "    blind - brightness manager"
    echo
    echo "USAGE:"
    echo "    blind DEVICE OPTION"
    echo
    echo "DEVICE:"

    readarray -t devices < <(\
        awk '/^case/,/^esac/' "$0" |
            grep -E '^    [a-z|]*)$' |
            sed 's/)//g;s/ //g')

    printf "    %s\n" "${devices[@]}"

    echo
    echo "OPTION:"

    awk '/^    case/,/^    esac/' "$0" |
        grep -E "^\s*(#|;;|[^*]\)|-.*\))" |
        sed -E 's/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g'

}

control_keybord_light(){
    max="$(brightnessctl "${@:2}" max)"

    step="$(( max / 9 ))"
    [[ "$step" = 0 ]] && step=1

    case "$1" in
        +)
            # Increase brightness
            set_value="+$step"
            ;;
        -)
            # Decrease brightness
            set_value="$step-"
            ;;
        --block)
            # Block compatible with Thonkbar
            curr="$(brightnessctl "${@:2}" get)"
            echo "$(( curr / step ))"
            exit
            ;;
        *)
            usage
            exit
            ;;
    esac

    brightnessctl "${@:2}" set "$set_value"
    pkill --signal 37 thonkbar
}

case "$1" in
    keyboard)
        control_keybord_light "$2" --device="*kbd*"
        ;;
    backlight)
        control_keybord_light "$2" --class="backlight" --min-value=6
        ;;
    *)
        usage
        ;;
esac
