#!/bin/bash
CACHE="$XDG_CACHE_HOME/dmenu"
cache_file="$CACHE""/IQhist"

mkdir -p "$CACHE"
[ ! -f "$cache_file" ] && touch "$cache_file"

all_cmd=$(dmenu_path)

most_used=$( \
    sort -nr -k2 "$cache_file" |
    cut -f1 |
    grep -F -x -f <(echo -e "$all_cmd"))

all_cmd=$(echo -e "$all_cmd" | grep -F -x -v -f <(echo -e "$most_used"))

cmd=$(echo -e "${most_used}\n${all_cmd}" | dmenu -i)

[ "$cmd" = "" ] && exit 2

if ! grep -q "$cmd" "$cache_file";
then
    echo -e "$cmd\t1" >> "$cache_file"
else
    tmp_cache="$(awk \
        -v c="$cmd" \
        -F'\t' \
        '$1 == c {print($1"\t"$2 + 1)} $1 != c {print}' "$cache_file")"

    echo "$tmp_cache" > "$cache_file"
fi

echo -e "$cmd" | ${SHELL:-"/bin/sh"} &
