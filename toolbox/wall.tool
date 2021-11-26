#!/bin/bash
# wallpaper manager (integrates with [dmenu](https://github.com/mendess/dmenu)) (color picker made by [mendess](https://github.com/mendess))

set -e
remote="kiwi"
folder=".local/share/wallpapers"

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
        rsync --exclude '.config' --delete -av "$remote:$folder/" "$HOME/$folder"
        return 0
    else
        echo -e "\e[31mCouldn't connect to server\e[0m"
        return 1
    fi
}

_check_res(){
    file="$HOME/$folder/$1"

    touch -m "$file"

    w="$(convert "$file" -format '%[w]' info:)"
    h="$(convert "$file" -format '%[h]' info:)"

    echo "$w"x"$h"

    if [[ "$w" -ge 1920 ]] && [[ "$h" -ge 1080 ]]; then
        return 0
    else
        echo -e "\033[31mImage too small\033[0m"
        rm "$file"
        return 1
    fi
}

_add_wall() {
    case "$1" in
        http*)
            if [[ "$(hostname)" != "$remote" ]]; then
                echo -e "\e[32mDownloading on $remote...\e[0m"
                ssh "$remote" ~/.local/bin/wall --add "$@"
            else
                file="$(basename "$1")"
                [[ "$2" ]] && file="$2"
                wget "$1" -O "$HOME/$folder/$file"
                _check_res "$file"
            fi
            ;;
        *)
            if [[ "$(hostname)" != "$remote" ]]; then
                _check_res "$1" && scp "$1" "$remote":"$folder"
            else
                cp -v "$1" "$HOME/$folder"
                _check_res "$1"
            fi
            ;;
    esac
}

_rm_wall() {
    readarray -t wall < <(sxiv -to "$HOME/$folder")
    for w in "${wall[@]}"; do
        # shellcheck disable=SC2029
        ssh "$remote" rm -v "$folder/$(basename "$w")" | sed "s/'/'jff.sh:/"
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

[[ ! -d "$HOME/$folder" ]] && _sync_walls

case "$1" in
    -a|--add)
        # Add wallpaper
        # Suports links and files
        _sync_walls || exit
        _add_wall "${@:2}"
        _sync_walls || exit
        ;;

    -rm|--remove)
        # Remove wallpaper using sxiv
        _sync_walls || exit
        _rm_wall
        ;;

    -s|--select)
        # Select wallpaper using sxiv
        _sync_walls || :
        file="$(sxiv -to "$HOME/$folder")"
        [[ "$file" ]] || exit
        _change_wall "$file"
        ;;

    --change|"")
        # Change to random wallpaper [default]
        _sync_walls || :
        file=$(find "$HOME/$folder" -type f | shuf -n 1)
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
