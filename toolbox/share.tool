#!/bin/bash
CACHE="$XDG_CACHE_HOME/fileshare"

_upload(){
    rsync -av --info=progress2 "$1" jff.sh:~/share
    url="http://jff.sh/share/$(basename "$1")"
    echo "$url" | xclip -sel clip
    echo "$url"
}

if [ -d "$1" ]
then
    mkdir -p "$CACHE"
    zip -r "$CACHE/$(basename "$1").zip" "$1"
    FILE="$CACHE/$(basename "$1").zip"
    _upload "$FILE"
    rm "$FILE"
else
    _upload "$1"
fi
