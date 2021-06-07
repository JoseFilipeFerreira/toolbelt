#!/bin/sh
# extract anything

for f in "$@"; do
    if [ ! -f "$f" ]; then
        echo "$f is not a valid file"
        exit
    fi
done

for f in "$@"; do
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 -v "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *.xz) xz -d "$1" ;;
        *) echo "$1 cannot be extracted via ex()" && exit ;;
    esac
done
