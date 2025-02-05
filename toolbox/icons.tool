#!/bin/bash
# icon pack manager for [toolicons](powertools/toolicons)
# https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html
# https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html

src_icons=~/.toolbelt/powertools/toolicons
dest_icons=/usr/share/icons/toolicons
tmp_index_file="$src_icons"/index.theme
index_file="$dest_icons"/index.theme

get_width(){ echo "$1" | grep -Eo '^[0-9]*'; }
get_height(){ echo "$1" | grep -Eo '[0-9]*$'; }

resolutions=(
8x8
16x16
32x32
64x64
128x128
256x256
512x512
)

max_res="${resolutions[-1]}"

contexts=(
actions
animations
apps
categories
devices
emblems
emotes
intl
mimetypes
places
status
)

program_name="$(basename "$0")"
send_help(){
echo "NAME
        $program_name - icon pack manager

SYNOPSIS
        $program_name [--add CATEGORY FILE] [--generate] [--check] [--completion]

OPTIONS
        --add CATEGORY FILE
            add an image to a given category to the repository

        --generate
            install or update icon pack to $dest_icons

        --check
            check if icon pack is installed and up to date

        --completion
            generate bash completion scripts

            hash $program_name &> /dev/null &&
                . <($program_name --completion)

CATEGORY"
printf "        %s\n" "${contexts[@]}"

}

_icons_completion(){
    local IFS=$'\n'

    if [[ "$3" == "--add" ]]; then
        # shellcheck disable=SC2154
        mapfile -t COMPREPLY < \
            <(compgen -W "${_icons_contexts[*]}" -- "$2")
    elif [[ "${#COMP_WORDS[@]}" -gt 3 ]] && [[ "${COMP_WORDS[-3]}" == "--add" ]]; then
        mapfile -t COMPREPLY < <(compgen -f -X -- "$2")
    else
        # shellcheck disable=SC2154
        mapfile -t COMPREPLY < \
            <(compgen -W "${_icons_options[*]}" -- "$2")
    fi
}

while (( "$#" )); do
    case $1 in
        --add)
            ADD=true
            CATEGORY="$2"
            FILE="$3"
            shift 2
            ;;
        --generate)
            GENERATE=true
            shift
            ;;
        --check)
            CHECK=true
            shift
            ;;
        --help)
            send_help
            exit
            ;;
        --completion)
            echo "_icons_options=( $(awk '/^while/,/^done/' "$0" |
                    grep -E "^\s*-.*" |
                    sed -Ez 's/[ \)]//g;s/\n/ /g') )"

            echo "_icons_contexts=( ${contexts[*]} )"
            declare -f _icons_completion
            echo "complete -F _icons_completion $program_name"
            exit
            ;;
        *)
            shift
            ;;
    esac
done


# add image if valid
if [[ "$ADD" ]]; then
    # check if category is valid
    # shellcheck disable=SC2076
    if [[ ! " ${contexts[*]} " =~ " $CATEGORY " ]]; then
        echo "Invalid CATEGORY: $CATEGORY"
        echo "List of valid categories:"
        printf "    - %s\n" "${contexts[@]}"
        exit
    fi
    # check if file is valid
    if [[ ! -f "$FILE" ]]; then
        echo "FILE does not exist: $FILE"
        exit
    fi

    img_res="$(identify -ping -format '%wx%h' "$FILE")"
    w="$(get_width "$img_res")"
    h="$(get_height "$img_res")"

    max_height="$(get_height "$max_res")"
    max_width="$(get_width "$max_res")"

    # check if resolution is valid
    if [ ! "$w" -eq "$max_width" ] || [ ! "$h" -eq "$max_height" ]; then
        echo "Invalid image size of ${w}x${h}"
        echo "Must be $max_res"
        exit
    fi

    # add icon to repo
    mkdir -p "$src_icons/$max_res"
    cp -v "$FILE" "$src_icons/$max_res/$CATEGORY"
fi

# get all icons
readarray -t icons < <(\
    find "$src_icons/$max_res" -mindepth 2 -type f \
        -exec bash -c \
            'echo "$(basename $(dirname $1))/$(basename $1)"' shell {} \;)

if [[ "$GENERATE" ]]; then

    # get used contexts
    readarray -t used_ctxs < <(\
        {
            for icon in "${icons[@]}"; do
                dirname "$icon"
            done
        } | sort -u
    )

    # create folder structure
    for res in "${resolutions[@]}"; do
        for ctx in "${used_ctxs[@]}"; do
            sudo mkdir -p "$dest_icons/$res/$ctx"
        done
    done

    # generate index.theme
    echo "[Icon Theme]
    Name=$(basename "$src_icons")
    Comment=Theme for toolbelt dotfiles
    Inherits=Adwaita" >| "$tmp_index_file"

    folders=()
    for res in "${resolutions[@]}" ; do
        for ctx in "${used_ctxs[@]}"; do
            folders+=( "$res/$ctx" )
        done
    done

    echo >> "$tmp_index_file"
    IFS=","; echo "Directories=${folders[*]}" >> "$tmp_index_file"

    for res in "${resolutions[@]}" ; do
        for ctx in "${used_ctxs[@]}"; do
            {
                echo
                echo ["$res/$ctx"]
                echo "Size=$(get_height "$res")"
                echo "Type=Fixed"
            } >> "$tmp_index_file"
        done
    done

    sudo cp "$tmp_index_file" "$index_file"

    # resize all icons from maxsize to lower sizes
    for res in "${resolutions[@]}"; do
        for icon in "${icons[@]}"; do
            orig="$src_icons/$max_res/$icon"
            dest="$dest_icons/$res/$icon"
            [[ -f "$dest" ]] && continue
            echo "create $res/$icon"
            sudo convert \
                -colorspace RGB \
                "$orig" -resize "$res" "$dest"
        done
    done
fi

if [[ "$CHECK" ]];then
    for res in "${resolutions[@]}"; do
        for icon in "${icons[@]}"; do
            [[ -f "$dest_icons/$res/$icon" ]] || exit 0
        done
    done
    exit 1
fi

