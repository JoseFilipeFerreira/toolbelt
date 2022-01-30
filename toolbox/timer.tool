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
        -h|--help)
            echo "USAGE:"
            echo "    $(basename $0) [OPTIONS] TIME"
            echo "OPTIONS:"
            echo "    -m, --message"
            echo "        Set the timer message"
            echo
            echo "    -s, --sound"
            echo "        Turn on timer sound"
            echo
            echo "    -h, --help"
            echo "        Send this help message"
            exit
            ;;
        *)
            input="$1"
            shift
            ;;
    esac
done

[[ ! "$input" ]] && echo "Time not set" && exit

{
    sleep "$input"

    notify-send \
        -u critical \
        -i "apps/timer" \
        -a "timer" \
        "Time is up: $input"\
        "$message"

    [[ $sound ]] && mpv --no-video "$DOTFILES/assets/timer.mp3" &>/dev/null
} & disown
