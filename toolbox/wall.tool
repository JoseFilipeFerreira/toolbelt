#!/bin/bash
# wallpaper manager (integrates with [dmenu](https://github.com/mendess/dmenu)) (color picker made by [mendess](https://github.com/mendess))

set -e
remote="kiwi"
remote_location=".local/share/wallpapers"
local_location="${WALLS:?Wallpaper location not set}"

BRIGHTNESS_FILTER='
import sys
import colorsys
chosen_colours = []
rejected_colors = []
for line in sys.stdin:
    line = line.strip()
    og_line = str(line)
    if line.startswith("#"):
        line = line[1:]
    rgb = tuple(int(line[i:i+2], 16)/255 for i in (0, 2, 4))
    hsl = colorsys.rgb_to_hls(*rgb)
    hsv = colorsys.rgb_to_hsv(*rgb)
    text = "#000000" if hsl[1] >= .49 else "#FFFFFF"
    l = rejected_colors if hsv[1] < 0.2 or hsv[2] < 0.3 else chosen_colours
    l.append([og_line, [*rgb], text])

def rgb_distance(c0, c1):
    return sum([pow(c0[1][i] - c1[1][i], 2) for i in (0, 1, 2)])

if len(chosen_colours) < 3:
    chosen_colours += rejected_colors

first, contrast = chosen_colours[:2]
max_distance = rgb_distance(first, contrast)

for c in chosen_colours[2:]:
    d = rgb_distance(first, c)
    if d > max_distance:
        max_distance, contrast = d, c
second = chosen_colours[1 if contrast != chosen_colours[1] else 2]

for c, _, t in [first, second, contrast]: print(c, t)
'
_sync_walls() {
    [[ "$(hostname)" == "$remote" ]] && return 0

    if ssh -q "$remote" exit
    then
        echo -e "\033[32mSyncing Walls...\033[0m"
        rsync --exclude '.config' --delete -av "$remote:$remote_location/" "$local_location"
        return 0
    else
        echo -e "\e[31mCouldn't connect to server\e[0m"
        return 1
    fi
}

_add_wall() {
    case "$1" in
        http*)
            if [ "$2" = "" ]; then
                wget "$1" -P "$local_location"
                file="$(basename "$1")"
            else
                wget "$1" -O "$local_location/$2"
                file="$2"
            fi
        ;;
        *)
            cp -v "$1" "$local_location"
            file="$(basename "$1")"
        ;;
    esac

    touch -m "$local_location/$file"

    w="$(convert "$local_location/$file" -format '%[w]' info:)"
    h="$(convert "$local_location/$file" -format '%[h]' info:)"

    echo "$w"x"$h"

    if [ "$(echo "$w" | awk '$0 >= 1920 {print("true")}')" = true ] && [ "$(echo "$h" | awk '$0 >= 1080 {print("true")}')" = true ]
    then
        [[ "$(hostname)" == "$remote" ]] || \
            rsync -av "$local_location"/ "$remote":"$remote_location"
    else
        rm "$local_location/$file"
        echo -e "\033[31mImage too small\033[0m"
    fi

}

_rm_wall() {
    wall=$(sxiv -to "$local_location")
    for w in $wall; do
        #shellcheck disable=SC2029
        ssh "$remote" \
            "find $remote_location -type l,f -name '$(basename "$w")' | xargs rm -v" | sed "s/'/'jff.sh:/"
        rm -v "$w"
    done
}

_change_wall(){
    file=$1

    feh --no-fehbg --bg-fill "$file"

    mapfile -t colors < <(
        convert "$file" +dither -colors 10 histogram: |
            sed -n '/comment={/,/^}/p' |
            sed -E 's/comment=\{\s*|\}|^\s*//g' |
            awk '/[0-9]e\+[0-9]/ { split($0, s, "e+"); base=s[1]; split(s[2], ss, ":"); exponent=ss[1]; print((base * (10^exponent)) ":" ss[2]); }
                 $0 !~ /[0-9]e\+[0-9]/ {print}' |
            sort -nr |
            grep -aoP '#[a-fA-F0-9]{6}' |
            python3 -c "$BRIGHTNESS_FILTER" |
            head -3
    )

    printf "%s\n" "${colors[@]}" >| /tmp/wall_colors

    echo "$file"
    notify-send \
        -u low \
        -i "mimetypes/image-x-generic" \
        -a "wall" \
        "Wallpaper changed" \
        "$(basename "$file")"
}

[[ ! -d "$local_location" ]] && _sync_walls

case "$1" in
    -a|--add)
        # Add wallpaper
        # Suports links and files
        _sync_walls || exit
        _add_wall "${@:2}"
        ;;

    -rm|--remove)
        # Remove wallpaper using sxiv
        _sync_walls || exit
        _rm_wall
        ;;

    -s|--select)
        # Select wallpaper using sxiv
        _sync_walls || :
        file="$(sxiv -to "$local_location")"
        [[ "$file" ]] || exit
        _change_wall "$file"
        ;;

    --change|"")
        # Change to random wallpaper [default]
        _sync_walls || :
        file=$(find "$local_location" -type f | shuf -n 1)
        _change_wall "$file"
        ;;

    -h|--help)
        # Send this help message
        echo "NAME:"
        echo "    wall - wallpaper manager"
        echo
        echo "USAGE:"
        echo "    wall [OPTIONS]|FILE"
        echo
        echo "OPTIONS:"

        awk '/^case/,/^esac/' "$0" |
            grep -E "^\s*(#|-.*|;;)" |
            sed -E 's/\|\"\"//g;s/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g'
        ;;

    *)
        _change_wall "${@:1}"
        ;;
esac
