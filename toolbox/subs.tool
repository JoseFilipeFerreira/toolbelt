#!/bin/bash
FILE="$XDG_CONFIG_HOME/newsboat/urls"

CATS="$(grep -o -e '---.*---' "$FILE" | sed "s/---//g")"

echo "$CATS"
