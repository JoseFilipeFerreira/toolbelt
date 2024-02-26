#!/bin/bash
# screenshot tool (Wayland support by [mendess](https://github.com/mendess))

rename(){
    # by Mendess (https://github.com/mendess/)
    if [[ "$wayland" ]]; then
        picker=(tofi --prompt-text 'rename to ' --require-match=false --height=40 --horizontal=true)
    else
        picker=(dmenu -p 'rename to')
    fi
    rename="$(: | "${picker[@]}" |
        sed -E 's/^\s *//; s/\s*$//; s/\s+/_/g')"
    [[ -z "$rename" ]] && return 1
    while [[ -e "${rename}${i}" ]]; do
        ((i++))
    done
    rename="${rename}${i}.${1#*.}"
    mv "$1" "$rename" && echo "$rename"
}

script_name="$(basename "$0")"

file="$(date +'screenshot_%d%h%Y-%Hh%Mm%Ss')"

if [[ "$XDG_SESSION_TYPE" = wayland ]]; then
    wayland=1
fi

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
            # Display in floating sxiv/nsxiv
            display="floating"
            shift
            ;;
        -v|--video)
            # Record video
            #
            # If script is executed through a keybind stop recording with
            #     kill -SIGINT $(cat /tmp/$USER/ffmpeg_screenshot_pid)
            # else stop recording with q or <C-c>
            type="video"
            shift
            ;;
        -s|--select)
            # Select area to print
            if [[ $wayland ]]; then
                hack=$(slurp)
            else
                hack="$(hacksaw)"
            fi
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
        --color-picker)
            # get more common color in image
            # copies value to selection
            pick="true"
            shift
            ;;
        --qrcode)
            # reads Qr code in image
            # copies value to selection
            qrcode="true"
            shift
            ;;
        -h|--help)
            # Send this help message
            echo "NAME"
            echo "        $script_name - supercharged screenshot tool"
            echo
            echo "SYNOPSIS"
            echo "        $script_name [OPTIONS] FILE"
            echo
            echo "OPTIONS"

            awk '/^while/,/^done/' "$0" |
                grep -E "^\s*(#|-.*|;;)" |
                sed -E 's/\|/, /g;s/(\)$)//g;s/# //g;s/#//g;s/;;//g' |
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

[[ "$hack" ]] || if [[ "$wayland" ]]; then
    hack="0,0 $(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')"
else
    hack="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')+0+0"
fi

[[ "$delay" ]] && sleep "$delay"

[[ "$hack_info" ]] && content="of area "

notify(){
    [[ "$no_notify" ]] && return

    [[ "$delay" ]] && content+="with delay of ${delay}s"
    [[ "$display" ]] && content+="to $display "
    [[ "$new_file" ]] && content+="renamed to $new_file "

    if [[ "$pick" ]]; then
        color="$(convert "$thumbnail" \
            -define histogram:unique-colors=true \
            -format %c \
            histogram:info:- |
            sort -n |
            sed '$!d' |
            cut -d'#' -f2 |
            cut -c1-6)"
        echo -n "#$color" | xclip
        content+="(#$color) "
    fi

    if [[ "$qrcode" ]]; then
        if ! hash zbarimg; then
            echo "error: zbarimg not installed"
        else
            if qr="$(zbarimg -q "$thumbnail")"; then
                echo -n "$qr" | sed -E 's/QR-Code://g' | xclip
                content+="$qr"
            else
                content+="failed to read QR Code"
            fi
        fi
    fi

    image="image-x-generic"
    [[ -f "$thumbnail" ]] && image="$thumbnail"

    notify-send -u low -i "$image" -a "$script_name" "$type taken" "$content"
}

case "$type" in
    image)
        file="$file.png"

        if [[ "$wayland" = 1 ]]; then
            grim -g "$hack" "$file"
        else
            shotgun -g "$hack" "$file"
        fi

        if [[ "$rename" ]]; then
            if new_file="$(rename "$file")"; then
                file="$new_file"
            else
                rm "$file" && exit
            fi
        fi

        thumbnail="$PWD/$file"

        notify
        case "$display" in
            floating)
                if hash sxiv &> /dev/null; then
                    sxiv -p -g "$hack" -b "$file"
                elif hash nsxiv &> /dev/null; then
                    nsxiv -p -g "$hack" -b "$file"
                else
                    echo "sxiv/nsxiv not available"
                fi
                [[ "$keep" ]] || rm "$file"
                ;;
            clip)
                if [[ "$wayland" = 1 ]]; then
                    wl-copy -t 'image/png' < "$file"
                else
                    xclip -t 'image/png' -selection clipboard -i "$file"
                fi
                [[ "$keep" ]] || rm "$file"
                ;;
            *)
                ;;
        esac
        ;;
    video)
        file="$file.mkv"

        flags=(-framerate 25 -f x11grab)

        if [[ "$wayland" ]]; then
            # TODO FIX $hack format
            notify-send -u critical "Can't record video in wayland" "soon ™️"
            exit 1
        fi

        [[ "$time" ]] && flags+=( -t "$time" ) && content+="during ${time}s "
        size="$(echo "$hack" | cut -d+ -f 1)"
        start="$(echo "$hack" | cut -d+ -f 2,3 --output-delimiter=,)"

        flags+=(-video_size "$size" -i :0.0+"$start")

        if [[ -t 1 ]]; then
            ffmpeg "${flags[@]}" "$file"
        else
            ffmpeg "${flags[@]}" "$file" &

            pid_file="/tmp/$USER/ffmpeg_screenshot_pid"
            mkdir -p "$(dirname "$pid_file")"

            jobs -p > "$pid_file"
            wait
            rm "$pid_file"
        fi

        if [[ "$rename" ]]; then
            if new_file="$(rename "$file")"; then
                file="$new_file"
            else
                rm "$file" && exit
            fi
        fi

        thumbnail="$(mktemp --suffix=.png)"

        ffmpeg -y -loglevel error -hide_banner -vsync vfr -i "$file"  -frames:v 1 "$thumbnail" > /dev/null

        notify
        ;;
esac

