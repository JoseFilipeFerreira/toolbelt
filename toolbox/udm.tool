#!/bin/bash
# playlist manager

set -e
ydl_flags=(-f 'bestaudio' -x --add-metadata --no-playlist --audio-format mp3 -o "'media/music/%(title)s.%(ext)s'")

remote_location="/home/mightymime/media/music"

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
        rsync -av kiwi:"$remote_location/" "$MUSIC"
        echo -e "\e[35mDone!\e[0m"
    else
        echo -e "\e[31mCouldn't connect to server"
        [ "$EXIT" ] || exit
    fi
}

_add_music() {
    case "$1" in
        --clipboard|-c)
            link="$(xclip -sel clip -o)"
            echo -n "add link ($link) [Y/n] "
            read -r
            case $REPLY in
                "y"|"Y"|"")
                    _add_music  ""
                    ;;
            esac
            return
        ;;
        http*youtube*)
            ssh kiwi youtube-dl "${ydl_flags[@]}" "'$1'"
        ;;
        http*)
            if [[ ! "$2" ]]; then
                ssh kiwi wget "$1" -P "$remote_location"
            else
                ssh kiwi wget "$1" -O "$remote_location/$2"
            fi
        ;;
        *)
            scp -v "$1" kiwi:"$MUSIC"
        ;;
    esac
    ssh kiwi ~/.local/bin/nospace "$remote_location"/*
    _sync_music --no-exit --title="Syncing"
}

_discord_music() {
    website="http://jff.sh/music"
    music_link=$(curl "$website" | grep '<a' | cut -d"'" -f2 | shuf | nl)
    n_lines="$(echo "$music_link" | wc -l)"

    sleep 3

    prefix="."
    [[ $1 ]] && prefix="$1"

    echo "$music_link" |
        while read -r link; do
            n="$(echo "$link" | awk '{print $1}')"
            l="$(echo "$link" | awk '{print $2}')"
            xdotool type "$prefix""play <$website/$(basename -- "$l")>"
            xdotool key 'Return'
            echo -en "\r\e[K$n/$n_lines"
            sleep 4
        done
    echo
    xdotool type "$prefix""shuffle"
    xdotool key 'Return'
}

[ -d "$MUSIC" ] || _sync_music --title="Dowloading"

case "$1" in
    --add|-a)
        _add_music "${@:2}"
        ;;
    --play|-p)
        _sync_music --no-exit --title="Syncing"
        mpv --shuffle --no-video "$MUSIC"
        ;;
    --select|-s)
        file="$(find "$MUSIC"  -type f -printf "%f\n" | fzf )"
        mpv --no-video "$MUSIC/$file"
        ;;
    --discord|-d)
        _discord_music "${@:2}"
        ;;
    --help|-h)
        echo -e "NAME\n\tudm - playlist manager\n"
        echo -e "DESCRIPTION"
        echo -e "\t--add, -a"
        echo -e "\t\tadd music to playlist"
        echo -e "\t\tadd -c to get link from clipboard"
        echo -e "\t--play, -p"
        echo -e "\t\tshuffle music from playlist"
        echo -e "\t--select, -s"
        echo -e "\t\tselect music using fzf"
        echo -e "\t--discord, -d"
        echo -e "\t\tplay playlist on discord"

esac
