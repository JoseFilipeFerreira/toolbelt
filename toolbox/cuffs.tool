#!/bin/bash
# screenshot tool

script_name="$(basename "$0")"

file=$(date +'%d%h%Y-%Hh%mm%Ss')

type="image"

while (( "$#" )); do
    case $1 in
        --clipboard|-c)
            clip="true"
            shift
            ;;
        --video|-v)
            type="video"
            shift
            ;;
        --image|-i)
            type="image"
            shift
            ;;
        --select|-s)
            hack="$(hacksaw)"
            shift
            ;;
        --delay|-d)
            delay="$2"
            shift 2
            ;;
        --time|-t)
            time="$2"
            shift 2
            ;;
        ""|-h|--help)
            echo "USAGE:"
            echo "    $script_name [FALGS] [OPTIONS] [FILE]"
            echo
            echo "FLAGS:"
            echo -e "    -h, --help\tPrint help and exit"
            echo
            echo "OPTIONS:"
            echo "    -c, --clipboard"
            echo "        Print to clipboard"
            echo
            echo "    -s, --select"
            echo "        Select area to print"
            echo
            echo "    -d, --delay <delay>"
            echo "        Delay before taking print (seconds)"
            echo
            echo "    -i, --image"
            echo "        Take screenshot [default]"
            echo
            echo "    -v, --video"
            echo "        Record video"
            echo
            echo "    -t, --time <time>"
            echo "        Record time (seconds)"
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

[[ "$delay" ]] && sleep "$delay"

case $type in
    image)
        flags=()
        [[ "$hack" ]] && flags+=( -g "$hack")

        if [[ "$clip" ]]; then
            shotgun ${flags[@]} - | xclip -t 'image/png' -selection clipboard
        else
            shotgun ${flags[@]} "$file.png"
        fi

        ;;
    video)
        flags=(-framerate 25 -f x11grab)

        [[ "$time" ]] && flags+=( -t "$time" )
        if [[ "$hack" ]]; then
            size="$(echo "$hack" | cut -d+ -f 1)"
            start="$(echo "$hack" | cut -d+ -f 2,3 --output-delimiter=,)"
        else
            size="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')"
            start="0,0"
        fi

        flags+=(-video_size "$size" -i :0.0+"$start")

        ffmpeg ${flags[@]} "$file.mp4"
        ;;
esac
