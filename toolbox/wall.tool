#!/bin/bash
# wallpaper manager (integrates with [dmenu](https://github.com/mendess/dmenu))

set -e
remote_location="/home/mightymime/media/wallpapers"

IMAGE_COLOR_FILTER='
import sys
import colorsys
outputs = 0
last_colors = []
for line in sys.stdin:
    line = line.strip()
    og_line = str(line)
    line = line.lstrip("#")

    rgb = tuple(int(line[i:i+2], 16)/255 for i in (0, 2, 4))
    hsv = colorsys.rgb_to_hsv(*rgb)
    hsl = colorsys.rgb_to_hls(*rgb)

    text_color = "#FFFFFF" if hsl[1] < 0.5 else "#000000"

    if hsv[1] < 0.2 or hsv[2] < 0.3:
        last_colors.append((og_line, text_color))
    else:
        outputs += 1
        print(og_line, text_color)

while len(last_colors) < 3:
    last_colors.append(("#000000", "#FFFFFF"))

if outputs < 3:
    for i in last_colors[:(3 - outputs)]:
        print(i)
    print(
        "Not enough colors picked, resorting to most common",
        file=sys.stderr)
'

_add_wall() {
    case "$1" in
        http*)
            if [ "$2" = "" ]; then
                wget "$1" -P "$WALLS"
                file="$(basename "$1")"
            else
                wget "$1" -O "$WALLS/$2"
                file="$2"
            fi
        ;;
        *)
            cp -v "$1" "$WALLS"
            file="$(basename "$1")"
        ;;
    esac

    cd "$WALLS"

    res="$(convert "$file" -format '%[w]' info:)"
    if [ "$(echo "$res" | awk '$0 >= 1920 {print("true")}')" = true ]
    then
        rsync -av "$WALLS"/ kiwi:"$remote_location"
    else
        rm "$file"
        echo -e "\033[31mImage too small\033[0m\nonly $res"
    fi

}

_rm_wall() {
    wall=$(sxiv -to "$WALLS")
    for w in $wall; do
        ssh jff.sh \
            "find $remote_location -type l,f -name '$(basename "$w")' | xargs rm -v" | sed "s/'/'jff.sh:/"
        rm -v "$w"
    done
}

_change_wall(){
    file=$1

    feh --no-fehbg --bg-fill "$file"

    echo "$(convert "$file" +dither -colors 10 histogram: |
        grep -aoP '[0-9][0-9][0-9]+:.*$' |
        grep -aoP '#[^ ].....' |
        python3 -c "$IMAGE_COLOR_FILTER" |
        head -3)"  >| /tmp/wall_colors

    echo "$file"
    notify-send \
        -u low \
        -i "$DOTFILES/assets/image_placeholder.png" \
        -a "wall" \
        "Wallpaper changed" \
        "$(basename "$file")"
}

if [ ! -d "$WALLS" ]
then
    echo -e "\033[35mDowloading Wallpapers...\033[33m"
    rsync -av kiwi:"$remote_location"/ "$WALLS"
    echo -e "\033[35mDone!\033[0m"
fi

case "$1" in
    --add|-a)
        _add_wall "${@:2}"
        ;;
    --remove|-rm)
        _rm_wall
        ;;
    --select|-s)
        file="$(sxiv -to "$WALLS")"
        [[ "$file" ]] || exit
        _change_wall "$file"
        ;;
    "")
        file=$(find "$WALLS" -type f | shuf -n 1)
        _change_wall "$file"
        ;;
    *)
        _change_wall "${@:1}"
        ;;
esac
