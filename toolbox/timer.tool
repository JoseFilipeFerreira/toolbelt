#!/bin/bash
# timer with message and alarm sound

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

w="$(sed -En 's/.*([0-9]+)w.*/\1/p' <<<"$input")"
d="$(sed -En 's/.*([0-9]+)d.*/\1/p' <<<"$input")"
h="$(sed -En 's/.*([0-9]+)h.*/\1/p' <<<"$input")"
m="$(sed -En 's/.*([0-9]+)m.*/\1/p' <<<"$input")"
s="$(sed -En 's/.*([0-9]+)s.*/\1/p' <<<"$input")"

s=$((s
    + m * 60
    + h * 60 * 60
    + d * 60 * 60 * 24
    + w * 60 * 60 * 24 * 7))
[[ ! "$s" ]] && echo "Error: Invalid time" && exit

{
sleep "$s"

notify-send \
    -u critical \
    -i "$DOTFILES/assets/timer.png" \
    -a "timer" \
    "Time is up: $input"\
    "$message"

[[ $sound ]] && mpv --no-video "$DOTFILES/assets/timer.mp3" &>/dev/null

} & disown
