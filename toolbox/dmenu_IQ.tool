#!/bin/bash
# dmenu app launcher with app usage history

cache="$XDG_DATA_HOME/dmenu"
mkdir -p "$cache"
cache_file="$cache""/IQhist"
touch "$cache_file"

all=$(dmenu_path | grep -E '[[:alnum:]]')

used=$(cut -f2- "$cache_file")

echo "${used[*]}"

not_used=$(echo -e "$all" | grep -Fxvf <(echo -e "$used"))

cmd=$(echo -e "${used}\n${not_used}" | dmenu -l 20 -i)

[[ "$cmd" ]] || exit 1

if ! grep -q "$cmd" "$cache_file"; then
    echo -e "1\t$cmd" >> "$cache_file"
else
    tmp_cache="$(mktemp)"

    awk -v c="$cmd" \
        -F'\t' \
        '$2 == c {print($1 + 1"\t"$2)} $2 != c {print}' \
        "$cache_file" |
    sort -nr > "$tmp_cache"

    mv "$tmp_cache" "$cache_file"
fi

case $cmd in
    *\; ) "$TERMINAL" -e "$(printf "%s" "${cmd}" | cut -d';' -f1)";;
    * ) ${cmd} & disown ;;
esac
