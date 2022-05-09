#!/bin/bash
# share files in my webserver

cache="$XDG_CACHE_HOME/fileshare"

upload(){
    rsync -av --info=progress2 "$1" kiwi:~/share
    url="http://jff.sh/share/$(basename "$1")"
    echo "$url" | xclip -sel clip
    echo "$url"
}

if [ -d "$1" ]; then
    mkdir -p "$cache"
    zip -r "$cache/$(basename "$1").zip" "$1"
    file="$cache/$(basename "$1").zip"
    upload "$file"
    rm "$file"
else
    upload "$1"
fi
