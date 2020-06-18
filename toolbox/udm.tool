#!/bin/bash
set -e
YDL_FLAGS=(-f 'bestaudio' -x --add-metadata --no-playlist --audio-format mp3 -o "'music/%(title)s.%(ext)s'")

_sync_music() {
    for i in "$@"; do
        case $i in
            -t=*|--title=*)
                TITLE="${i#*=}"
                shift
                ;;
            --no-exit)
                EXIT="no"
                shift
                ;;
        esac
    done

    if ssh -q kiwi exit
    then
        echo -e "\e[35m$TITLE Music...\e[33m"
        rsync -av kiwi:~/music/ "$MUSIC"
        echo -e "\e[35mDone!\e[0m"
    else
        echo -e "\e[31mCouldn't connect to server"
        [ "$EXIT" ] || exit
    fi
}

_add_music() {
    case "$1" in
        --clipboard|-c)
            _add_music  "$(xclip -sel clip -o)"
        ;;
        http*youtube*)
            ssh kiwi youtube-dl "${YDL_FLAGS[@]}" "'$1'"
            ssh kiwi ~/.local/bin/nospace ~/music/*
        ;;
        http*)
            if [ "$2" = "" ]; then
                ssh kiwi wget "$1" -P ~/music
            else
                ssh kiwi wget "$1" -O ~/music/"$2"
            fi
            ssh kiwi ~/.local/bin/nospace ~/music/*
        ;;
        *)
            scp -v "$1" kiwi:"$MUSIC" 
            ssh kiwi ~/.local/bin/nospace ~/music/*
        ;;
    esac
    _sync_music --no-exit --title="Syncing"
}

_discord_music() {
    WEBSITE="http://jff.sh/music"
    sleep 3
    MUSIC_LINK=$(curl "$WEBSITE" | grep '<a' | cut -d"'" -f2 | shuf | nl)
    N_LINES="$(echo "$MUSIC_LINK" | wc -l)"

    echo "$MUSIC_LINK" |
        while read -r link; do
            n="$(echo "$link" | awk '{print $1}')"
            l="$(echo "$link" | awk '{print $2}')"
            xdotool type ".play <$WEBSITE/$(basename -- "$l")>"
            xdotool key 'Return'
            echo -en "\r\e[K$n/$N_LINES"
            sleep 4
        done
    echo
    xdotool type ".shuffle"
    xdotool key 'Return'
}

[ -d "$MUSIC" ] || _sync_music --title="Dowloading"

case "$1" in
    add)
        _add_music "${@:2}"
        ;;
    play)
        _sync_music --no-exit --title="Syncing"
        mpv --shuffle --no-video "$MUSIC"
        ;;
    discord)
        _discord_music "${@:2}"
esac
