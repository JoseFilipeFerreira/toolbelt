#!/bin/bash

while (( "$#" )); do
    case $1 in
        -m|--message)
            message="$2"
            shift
            shift
            ;;

        -s|--sound)
            sound="true"
            shift
            ;;
        *)
            input="$1"
            shift
            ;;
    esac
done

week="$(echo "$input" | grep -Eo "[0-9]+w" | sed 's/[^0-9]*//g')"
day="$(echo "$input" | grep -Eo "[0-9]+d" | sed 's/[^0-9]*//g')"
hour="$(echo "$input" | grep -Eo "[0-9]+h" | sed 's/[^0-9]*//g')"
min="$(echo "$input" | grep -Eo "[0-9]+m" | sed 's/[^0-9]*//g')"
sec="$(echo "$input" | grep -Eo "[0-9]+s" | sed 's/[^0-9]*//g')"

[[ "$min" ]] && sec=$((sec + min * 60))
[[ "$hour" ]] && sec=$((sec + hour * 60 * 60))
[[ "$day" ]] && sec=$((sec + day * 60 * 60 * 24))
[[ "$week" ]] && sec=$((sec + week * 60 * 60 * 24 * 7))

{
sleep "$sec"

notify-send \
    -u critical \
    -i "$DOTFILES/assets/timer.png" \
    -a "timer" \
    "Time is up: $input"\
    "$message"

[[ $sound ]] && mpv --no-video "$DOTFILES/assets/timer.mp3" &>/dev/null

} & disown
