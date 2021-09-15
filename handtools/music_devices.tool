#!/data/data/com.termux/files/usr/bin/bash
# choose a remote device to connect with history

cache_file=~/.cache/music_device

_all(){
        grep "^Host" ~/.ssh/config | sed 's/Host //g'
}

[ -f "$cache_file" ] || _all | head -1 >| "$cache_file"

case "$1" in
    --last-used)
        cat "$cache_file"
        ;;
    --set-last)
        echo "$2" >| "$cache_file"
        ;;
    --all)
        last="$(cat "$cache_file")"
        echo -e "$last\n$(_all | grep -v "$last")" | paste -s -d, -
        ;;
esac
