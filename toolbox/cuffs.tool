#!/bin/bash
# screenshot tool

script_name="$(basename "$0")"

file=$(date +'%d%h%Y-%Hh%mm%Ss')

type="image"

while (( "$#" )); do
    case $1 in
        -c|--clipboard)
            # Print to clipboard
            clip="true"
            shift
            ;;
        -i|--image)
            # Take screenshot [default]
            type="image"
            shift
            ;;
        -d|--delay)
            # Delay before taking print in seconds
            delay="$2"
            shift 2
            ;;
        -f|--floating)
            # Display in floating sxiv
            display="floating"
            shift
            ;;
        -v|--video)
            # Record video
            type="video"
            shift
            ;;
        -s|--select)
            # Select area to print
            hack="$(hacksaw)"
            shift
            ;;
        -t|--time)
            # Record time in seconds
            time="$2"
            shift 2
            ;;
        -h|--help)
            # Send this help message
            echo "USAGE:"
            echo "    $script_name [OPTIONS] FILE"
            echo
            echo "OPTIONS:"

            awk '/^while/,/^done/' "$0" |
                grep -E "^\s*(#|-.*|;;)" |
                sed -E 's/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g'
            exit
            ;;
        *)
            file="$1"
            file="${file%%.*}"
            shift
            ;;
    esac
done

[[ "$clip" ]] && [[ "$type" == "video" ]] \
    && echo "Options --clipboard and --video are incompatible" >&2 \
    && exit

[[ "$clip" ]] && [[ "$display" == "floating" ]] \
    && echo "Options --clipboard and --floating are incompatible" >&2 \
    && exit

[[ "$hack" ]] || hack="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')+0+0"

[[ "$delay" ]] && sleep "$delay"

case $type in
    image)
        if [[ "$clip" ]]; then
            shotgun -g "$hack" - | xclip -t 'image/png' -selection clipboard
        else
            shotgun -g "$hack" "$file.png"
        fi

        case "$display" in
            floating)
                sxiv -g "$hack" -b "$file.png"
                rm "$file.png"
        esac

        ;;
    video)
        flags=(-framerate 25 -f x11grab)

        [[ "$time" ]] && flags+=( -t "$time" )
        size="$(echo "$hack" | cut -d+ -f 1)"
        start="$(echo "$hack" | cut -d+ -f 2,3 --output-delimiter=,)"

        flags+=(-video_size "$size" -i :0.0+"$start")

        ffmpeg "${flags[@]}" "$file.mkv"
        ;;
esac
