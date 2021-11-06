#!/bin/bash
# manage [toolicons](powertools/toolicons) icon theme
# https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html
# https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html

src_icons="$DOTFILES"/powertools/toolicons
dest_icons=/usr/share/icons/toolicons
tmp_index_file="$src_icons"/index.theme
index_file="$dest_icons"/index.theme

_get_width(){ echo "$1" | grep -Eo '^[0-9]*'; }
_get_height(){ echo "$1" | grep -Eo '[0-9]*$'; }

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


# add image if valid
if [ "$1" ] && [ "$2" ]; then
    if [[ ! " ${contexts[*]} " =~ " $1 " ]]; then
        echo "Invalid context $1"
        echo "Can only be: ${contexts[*]}"
        exit
    fi

    [ ! -f "$2" ] && echo "$2 is not a valid file" && exit

    img_res="$(identify -ping -format '%wx%h' "$2")"
    w="$(_get_width "$img_res")"
    h="$(_get_height "$img_res")"

    max_height="$(_get_height "$max_res")"
    max_width="$(_get_width "$max_res")"

    if [ "$w" -eq "$max_width" ] && [ "$h" -eq "$max_height" ]; then
        mkdir -p "$src_icons/$max_res"
        cp -v "$2" "$src_icons/$max_res/$1"
    else
        echo Invalid image size of "$w"x"$h"
        echo Must be "$max_res"
    fi
fi

# get all icons
readarray -t icons < <(\
    find "$src_icons/$max_res" -mindepth 2 -type f \
        -exec bash -c \
            'echo "$(basename $(dirname $1))/$(basename $1)"' shell {} \;)


if [ "$1" == "check" ];then
    for res in "${resolutions[@]}"; do
        for icon in "${icons[@]}"; do
            dest="$dest_icons/$res/$icon"
            [[ -f "$dest_icons/$res/$icon" ]] || exit 1
        done
    done
    exit 0
fi

# get only the contexts that are used
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
            echo "Size=$(_get_height "$res")"
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
        sudo convert "$orig" -resize "$res" "$dest"
    done
done
