#!/bin/bash
# transmission-remote wrapper

transmission(){
    if [[ "$(hostname)" == "kiwi" ]]
    then
        transmission-remote "$@"
    elif nmap -T5 -sP kiwi 2> /dev/null | grep -q "Host is up"
    then
        transmission-remote kiwi "$@"
    else
        ssh kiwi 'transmission-remote '"$*"
    fi
}

notify(){
        notify-send \
            -u normal \
            -i "$DOTFILES/assets/transmission.png" \
            -a "tr" \
            "$1" \
            "$2"
}

case $1 in
    -a|--add)
        # Add a torrent
        res="$(transmission --add "$2" | grep -Eo '".*"' | sed 's/\"//g')"
        notify "Add torrent" "$res"
        ;;
    -l|--list)
        # List available torrents
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
        [[ "$id" ]] || return 0
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
            sed -E 's/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g'
        exit
        ;;
esac
