#!/bin/bash
# screenshot tool

# made by Mendess
rename() {
    rename="$(: | dmenu -p 'rename to' |
        sed -E 's/^\s *//; s/\s*$//; s/\s+/_/g')"
    [[ -z "$rename" ]] && return 1
    while [[ -e "${rename}${i}" ]]; do
        ((i++))
    done
    rename="${rename}${i}.${1#*.}"
    mv "$1" "$rename" && echo "$rename"
}

script_name="$(basename "$0")"

file="$(date +'screenshot_%d%h%Y-%Hh%mm%Ss')"

type="image"
while (( "$#" )); do
    case $1 in
        -c|--clipboard)
            # Print to clipboard
            display="clip"
            shift
            ;;
        -i|--image)
            # Take screenshot [default]
            type="image"
            shift
            ;;
        -k|--keep)
            # Do not delete screenshot when finished
            keep="true"
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
            hack_info="area"
            shift
            ;;
        -t|--time)
            # Record time in seconds
            time="$2"
            shift 2
            ;;
        --no-notify)
            # do not send notification at the end
            no_notify="true"
            shift
            ;;
        --rename)
            # Rename file at the end
            rename="true"
            shift
            ;;
        -h|--help)
            # Send this help message
            echo "USAGE:"
            echo "    $script_name [OPTIONS] FILE"
            echo
            echo "OPTIONS:"

            awk '/^while/,/^done/' "$0" |
                grep -E "^\s*(#|-.*|;;)" |
                sed -E 's/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g' |
                sed 's/ *$//g' |
                sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'
            exit
            ;;
        *)
            file="$1"
            file="${file%%.*}"
            shift
            ;;
    esac
done

[[ "$hack" ]] || hack="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')+0+0"

[[ "$delay" ]] && sleep "$delay"

[[ "$hack_info" ]] && content="of area"

case "$type" in
    image)
        file="$file.png"

        shotgun -g "$hack" "$file"

        case "$display" in
            floating)
                sxiv -p -g "$hack" -b "$file"
                [[ "$keep" ]] || delete="true"
                ;;
            clip)
                xclip -t 'image/png' -selection clipboard -i "$file"
                [[ "$keep" ]] || delete="true"
                ;;
            *)
                ;;
        esac

        [[ "$display" ]] && content+=" to $display"
        ;;
    video)
        file="$file.mkv"

        flags=(-framerate 25 -f x11grab)

        [[ "$time" ]] && flags+=( -t "$time" ) && content+=" during ""$time""s"
        size="$(echo "$hack" | cut -d+ -f 1)"
        start="$(echo "$hack" | cut -d+ -f 2,3 --output-delimiter=,)"

        flags+=(-video_size "$size" -i :0.0+"$start")

        ffmpeg "${flags[@]}" "$file"
        ;;
esac

[[ "$rename" ]] && file="$(rename "$file" || echo "$file")"

[[ "$no_notify" ]] || {

    [[ "$delay" ]] && content+=" with delay of ""$delay""s"

    image="mimetypes/image-x-generic"
    [[ -f "$file" ]] && [[ "$type" != "video" ]] && image="$PWD/$file"

    notify-send \
        -u low \
        -i "$image" \
        -a "$script_name" \
        "$type taken" \
        "$content"
}

[[ "$delete" ]] && rm "$file"
