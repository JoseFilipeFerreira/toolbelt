#!/bin/bash
CACHE="$XDG_CACHE_HOME/dmenu"
CACHE_FILE="$CACHE""/IQhist"

mkdir -p "$CACHE"
[ ! -f "$CACHE_FILE" ] && touch "$CACHE_FILE"

ALL_CMD=$(dmenu_path)

MOST_USED=$( \
    sort -nr -k2 "$CACHE_FILE" |
    cut -f1 |
    grep -F -x -f <(echo -e "$ALL_CMD"))

ALL_CMD=$(echo -e "$ALL_CMD" | grep -F -x -v -f <(echo -e "$MOST_USED"))

cmd=$(echo -e "${MOST_USED}\n${ALL_CMD}" | dmenu -i)

[ "$cmd" = "" ] && exit 2

if ! grep -q "$cmd" "$CACHE_FILE";
then
    echo -e "$cmd\t1" >> "$CACHE_FILE"
else
    TMP_CACHE="$(awk \
        -v c="$cmd" \
        -F'\t' \
        '$1 == c {print($1"\t"$2 + 1)} $1 != c {print}' "$CACHE_FILE")"

    echo "$TMP_CACHE" > "$CACHE_FILE"
fi

echo -e "$cmd" | ${SHELL:-"/bin/sh"} &
