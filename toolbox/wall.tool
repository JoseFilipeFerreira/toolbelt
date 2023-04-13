#!/bin/bash
# wallpaper manager (integrates with [dmenu](https://github.com/mendess/dmenu)) (color picker by [mendess](https://github.com/mendess))

set -e
remote="kiwi"
folder=".local/share/wallpapers"
color_cache=~/.cache/wall/colors

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
sync_walls(){
    [[ "$(hostname)" == "$remote" ]] && return 0

    if ssh -q "$remote" exit; then
        echo -e "\033[32mSyncing Walls...\033[0m"
        rsync --exclude '.config' --delete -av "$remote:$folder/" "$HOME/$folder"
        return 0
    else
        echo -e "\e[31mCouldn't connect to server\e[0m"
        return 1
    fi
}

check_res(){
    touch -m "$1"

    w="$(convert "$1" -format '%[w]' info:)"
    h="$(convert "$1" -format '%[h]' info:)"

    echo "resolution: ${w}x${h}"

    if [[ "$w" -ge 1920 ]] && [[ "$h" -ge 1080 ]]; then
        return 0
    else
        echo -e "\033[31mImage too small\033[0m"
        return 1
    fi
}

get_wall_colors(){
    filename="$(basename "$1")"

    if [[ -f "$color_cache/$filename" ]]; then
        cp "$color_cache/$filename" "/tmp/$USER/wall_colors"
    else
        mapfile -t colors < <(
            convert "$1" +dither -colors 10 histogram: |
                sed -n '/comment={/,/^}/p' |
                sed -E 's/comment=\{\s*|\}|^\s*//g' |
                awk '/[0-9]e\+[0-9]/ { split($0, s, "e+"); base=s[1]; split(s[2], ss, ":"); exponent=ss[1]; print((base * (10^exponent)) ":" ss[2]); }
                     $0 !~ /[0-9]e\+[0-9]/ {print}' |
                sort -nr |
                grep -aoP '#[a-fA-F0-9]{6}' |
                python3 -c "$BRIGHTNESS_FILTER" |
                head -3)

        mkdir -p "/tmp/$USER"
        printf "%s\n" "${colors[@]}" >| "/tmp/$USER/wall_colors"

        mkdir -p "$color_cache"
        printf "%s\n" "${colors[@]}" >| "$color_cache/$filename"
    fi
}

while (( "$#" )); do
    case "$1" in
        --sync)
            # Sync Wallpapers with remote
            SYNC="true"
            shift
            ;;
        -a|--add)
            # Add wallpaper
            # Suports links and files
            SYNC="true"
            ADD="true"
            ADD_CHOICE="$2"
            if [[ "$3" ]] && [[ ! "$3" = -* ]]; then
                ADD_RENAME="$3"
                shift 3
            else
                shift 2
            fi
            ;;

        -rm|--remove)
            # Remove wallpaper using nsxiv
            SYNC="true"
            REMOVE="true"
            shift
            ;;

        -s|--select)
            # Select wallpaper using nsxiv
            SYNC="true"
            SELECT="true"
            shift
            ;;

        --rng)
            # Change to random wallpaper
            RNG="true"
            shift
            ;;

        --fill-cache)
            # create color scheme cache
            SYNC="true"
            FILL_CACHE="true"
            shift
            ;;

        -h|--help)
            # Send this help message
            name="$(basename "$0")"
            echo "NAME"
            echo "        $name - wallpaper manager"
            echo
            echo "SINOPSYS"
            echo "        $name [OPTIONS] [FILE]"
            echo
            echo "OPTIONS"

            awk '/^    case/,/^    esac/' "$0" |
                grep -E "^\s*(#|-.*|;;)" |
                sed -E 's/\|\"\"//g;s/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g' |
                sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'

            shift
            ;;

        *)
            NEW_WALL="$1"
            shift
            ;;
    esac
done

if [[ ! -d "$HOME/$folder" ]] || [[ "$SYNC" ]]; then
    sync_walls || exit
fi


if [[ "$ADD" ]]; then
    case "$ADD_CHOICE" in
        http*)
            if [[ "$(hostname)" != "$remote" ]]; then
                echo -e "\e[32mDownloading on $remote...\e[0m"
                ssh "$remote" .local/bin/wall --add "$ADD_CHOICE" "$ADD_RENAME"
            else
                file="$(basename "$ADD_CHOICE")"
                [[ "$ADD_RENAME" ]] && file="$ADD_RENAME"
                destination="$HOME/$folder/$file"
                wget "$ADD_CHOICE" -O "$destination"
                check_res "$destination" || rm "$destination"
            fi
            ;;
        *)
            [[ ! -f "$ADD_CHOICE" ]] && echo "file does not exist" && exit
            if [[ "$(hostname)" != "$remote" ]]; then
                check_res "$ADD_CHOICE" && scp "$ADD_CHOICE" "${remote}:${folder}/${ADD_RENAME}"
            else
                check_res "$ADD_CHOICE" && cp -v "$ADD_CHOICE" "$HOME/$folder/$ADD_RENAME"
            fi
            ;;
    esac
    sync_walls
fi

if [[ "$REMOVE" ]];then
    readarray -t wall < <(nsxiv -to "$HOME/$folder")
    for w in "${wall[@]}"; do
        # shellcheck disable=SC2029
        ssh "$remote" rm -v "$folder/$(basename "$w")" | sed "s/'/'jff.sh:/"
        rm -v "$w"
    done
fi

if [[ "$SELECT" ]]; then
    [[ -d "$HOME/$folder" ]] || exit
    NEW_WALL="$(nsxiv -to "$HOME/$folder")"
    [[ "$NEW_WALL" ]] || exit
fi

if [[ "$RNG" ]]; then
    [[ -d "$HOME/$folder" ]] || exit
    NEW_WALL=$(find "$HOME/$folder" -type f | shuf -n 1)
    [[ "$NEW_WALL" ]] || exit
fi

if [[ "$NEW_WALL" ]]; then
    feh --no-fehbg --bg-fill "$NEW_WALL"

    [[ -f "$NEW_WALL" ]] && get_wall_colors "$NEW_WALL"

    echo "$NEW_WALL"
    notify-send -u low -i "$NEW_WALL" -a "wall" "Wallpaper changed" "$(basename "$NEW_WALL")"
fi

if [[ "$FILL_CACHE" ]]; then
    mkdir -p "$color_cache"
    touch "$color_cache/filler"
    for cache_file in "$color_cache"/*; do
        if [[ ! -f "$HOME/$folder/$(basename "$cache_file")" ]]; then
            rm "$cache_file"
        fi
    done

    total="$(find "$HOME/$folder" -type f | wc -l)"
    total_cache="$(find "$color_cache" -type f | wc -l)"
    missing="$(( total - total_cache ))"

    [[ "$missing" -le 0 ]] && return

    id="$(notify-send --print-id "Computing cache... ($i/$missing)")"

    i=1
    for image in "$HOME/$folder"/*; do

        filename="$(basename "$image")"

        if [[ ! -f "$color_cache/$filename" ]]; then
            notify-send \
                -r "$id" \
                -h int:value:"$(( i * 100 / missing ))" \
                -i "$image" \
                -a wall \
                "Computing cache... ($i/$missing)" "$filename"
            get_wall_colors "$image"
            i="$(( i + 1 ))"
        fi
    done
fi
