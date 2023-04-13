#!/bin/bash
# brightness control for screens and keyboards (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar) and [range2color](toolbox/range2color))

bar_signal_id=36
emoji_array=("" "" "" "" "" "" "")

name="$(basename "$0")"
usage(){
    echo "NAME"
    echo "        $name - brightness manager"
    echo
    echo "SYNOPSIS"
    echo "        $name OPTIONS"
    echo
    echo "OPTIONS"

    awk '/^    case/,/^    esac/' "$0" |
        grep -E "^\s*(#|;;|[^*]\)|(-)*[a-zA-Z]*\))" |
        sed -E 's/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g'
}

[[ ! "$1" ]] && usage && exit

max="$(brightnessctl "${brightnessctl_args[@]}" max)"
n_step="${#emoji_array[@]}"
step="$(( max / (n_step - 1) ))"
[[ "$step" = 0 ]] && step=1

brightnessctl_args=( "--class=backlight" "--min-value=6" )

while (( "$#" )); do
    case "$1" in
        keyboard)
            # Control the keyboard backlight
            brightnessctl_args=( "--device=*kbd*" )
            shift
            ;;
        backlight)
            # Control the screen backlight [default]
            shift
            ;;
        +)
            # Increase brightness
            set_value="+$step"
            shift
            ;;
        -)
            # Decrease brightness
            set_value="${step}-"
            shift
            ;;
        UP)
            # Increase brightness, with id as next arg
            set_value="+$step"
            [[ "$2" ]] || exit
            bar_signal_id="$2"
            shift 2
            ;;
        DOWN)
            # Decrease brightness, with id as next arg
            set_value="$step-"
            [[ "$2" ]] || exit
            bar_signal_id="$2"
            shift 2
            ;;
        --block)
            # Print a block compatible with Thonkbar
            print_block="true"
            shift
            ;;
        --help)
            # Send this help message and exit
            usage
            exit
            ;;
        *)
            shift
    esac
done


if [[ "$set_value" ]]; then
    brightnessctl "${brightnessctl_args[@]}" set "${set_value}"
    pkill --signal "$bar_signal_id" thonkbar
fi

if [[ "$print_block" ]]; then
    curr="$(brightnessctl "${brightnessctl_args[@]}" get)"
    echo "${emoji_array[curr/ step]}"
    range2color \
        --max-color "#FFFFFF" \
        --min-color "#727169" \
        --max "$max" \
        "$curr"
fi
