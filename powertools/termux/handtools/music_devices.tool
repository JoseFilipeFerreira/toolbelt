#!/data/data/com.termux/files/usr/bin/bash
# choose a remote device to connect with history

cache_file=~/.cache/music_device

list_devices(){
        grep "^Host" ~/.ssh/config | sed 's/Host //g'
}

[ -f "$cache_file" ] || list_devices | head -1 >| "$cache_file"

case "$1" in
    --last-used)
        cat "$cache_file"
        ;;
    --set-last)
        echo "$2" >| "$cache_file"
        ;;
    --all)
        last="$(cat "$cache_file")"
        echo -e "$last\n$(list_devices | grep -v "$last")" | paste -s -d, -
        ;;
esac
