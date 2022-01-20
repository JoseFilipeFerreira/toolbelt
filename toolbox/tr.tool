#!/bin/bash
# transmission-remote wrapper

# to setup for firefox:
# 1. open about:config
# 2. network.protocol-handler.expose.magnet = false
# 3. open magnet link and select ~/.local/bin/tr as default magnet link

remote="kiwi"

transmission(){
    if [[ "$(hostname)" == "$remote" ]]
    then
        transmission-remote "$@"
    elif nmap -T5 -sP "$remote" 2> /dev/null | grep -q "Host is up"
    then
        transmission-remote "$remote" "$@"
    else
        ssh "$remote" 'transmission-remote '"$*"
    fi
}

notify(){
    [ "$DISPLAY" ] &&
        notify-send \
            -u normal \
            -i "apps/transmission" \
            -a "tr" \
            "$1" "$2"
    echo "$1: $2"
}

_dl_torrent(){
        res="$(transmission --add "$1" | grep -Eo '".*"' | sed 's/\"//g')"
        notify "Add torrent" "$res"
}

case $1 in
    magnet:*)
        _dl_torrent "$1"
        ;;
    -a|--add)
        # Add a torrent
        _dl_torrent "$2"
        ;;
    -l|--list|"")
        # List available torrents [default]
        transmission --list
        ;;
    -rm|--delete)
        # Delete torrents using fzf
        list="$(transmission --list)"
        id="$(echo "$list" |
            grep -vP '^(\s+ID)|Sum:' |
            fzf --height="$(echo "$list" | wc -l)" --layout=reverse |
            awk '{print $1}' |
            grep -Eo "[0-9]*" )"
        [[ ! "$id" ]] && echo "No torrent specified" && exit
        res="$(transmission -t "$id" --remove | grep -Eo '".*"' | sed 's/\"//g')"
        notify "Delete torrent" "$res"
        ;;

    -h|--help)
        # Send this help message
        echo "USAGE:"
        echo "    tr OPTION LINK"
        echo
        echo "OPTIONS:"
        awk '/^case/,/^esac/' "$0" |
            grep -E "^\s*(#|-.*|;;)" |
            sed -E 's/\|\"\"//g;s/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g'
        exit
        ;;
esac
