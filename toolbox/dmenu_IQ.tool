#!/bin/bash
# dmenu app launcher with history

cache="$XDG_CACHE_HOME/dmenu"
cache_file="$cache""/IQhist"

mkdir -p "$cache"
touch "$cache_file"

all_cmd=$(dmenu_path)

most_used=$(sort -nr -k2 "$cache_file" | cut -f1)

never_used_cmd=$(echo -e "$all_cmd" | grep -F -x -v -f <(echo -e "$most_used"))

cmd=$(echo -e "${most_used}\n${never_used_cmd}" | dmenu -l 20 -i)

[[ "$cmd" ]] || exit 1

if ! grep -q "$cmd" "$cache_file";
then
    echo -e "$cmd\t1" >> "$cache_file"
else
    awk -v c="$cmd" \
        -F'\t' \
        '$1 == c {print($1"\t"$2 + 1)} $1 != c {print}' \
        "$cache_file" >| "$cache_file"
fi

case $cmd in
    *\; ) "$TERMINAL" -e "$(printf "%s" "${cmd}" | cut -d';' -f1)";;
    * ) ${cmd} ;;
esac
