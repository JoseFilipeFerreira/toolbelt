#!/bin/bash
# playlist manager

set -e
ydl_flags=(-f 'bestaudio' -x --add-metadata --no-playlist --audio-format mp3 -o "'media/music/%(title)s.%(ext)s'")

remote_location="/home/mightymime/media/music"

mpvsocket="/tmp/mpvsocket"

_update_bar(){
    pkill --signal 62 thonkbar
}

_sync_music() {
    for i in "$@"; do
        case $i in
            --title=*)
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


_mpv_play(){
    mpv --input-ipc-server="$mpvsocket" "$@"
}

_mpv_control(){
    echo "$1" | socat - "$mpvsocket"
}

_mpv_do() {
    _mpv_control '{ "command": '"$1"' }' |
        if [[ "$2" ]]; then jq "${@:2}"; else cat; fi
}

_mpv_get() {
    _mpv_do '["get_property", "'"$1"'"]' "${2:-.}" "${@:3}"
}

_media_control(){
    if pgrep mpv &>/dev/null; then
        _mpv_control "$1"
    else
        playerctl "$2"
        _update_bar
    fi
}

_echo_block(){
    path="$(_mpv_get "path" --raw-output .data 2>/dev/null)"

    [[ "$path" ]] || return

    case $path in
        http*)
            path="$(_mpv_get "media-title" --raw-output .data)"
            ;;
        *)
            path="$(basename "${path%.*}" | sed -E 's/-/ - /g;s/_/ /g')"
            ;;
    esac

    echo "$path"
    echo "$path"

    case "$(_mpv_get "pause" --raw-output .data)" in
        true)  echo "#696969" ;;
        false) echo "#00FF00" ;;
    esac
}

[ -d "$MUSIC" ] || _sync_music --title="Dowloading"

case "$1" in
    -a|--add)
        # Add music to playlist
        # Add -c to get link from clipboard
        _add_music "${@:2}"
        ;;

    -p|--play)
        # Shuffle music from playlist
        _sync_music --no-exit --title="Syncing"
        _mpv_play --shuffle --no-video "$MUSIC"
        ;;

    -s|--select)
        # Select music (uses fzf)
        _sync_music --no-exit --title="Syncing"
        file="$(find "$MUSIC"  -type f -printf "%f\n" | sort | fzf )"
        _mpv_play --no-video "$MUSIC/$file"
        ;;

    --discord)
        # Play playlist on discord
        _discord_music "${@:2}"
        ;;

    --stop)
        # Stop music
        _media_control 'quit' 'stop'
        ;;
    --play-pause)
        # Toggle play-pause
        _media_control 'cycle pause' 'play-pause'
        ;;
    --next)
        # Next music
        _media_control 'playlist-next' 'next'
        ;;
    --previous|--prev)
        # Previous music
        _media_control 'playlist-prev' 'previous'
        ;;

    --block)
        # Block compatible with i3blocks
        _echo_block
        ;;

    -h|--help)
        # Send this help message
        echo "NAME:"
        echo "    udm - playlist manager"
        echo
        echo "USAGE:"
        echo "    udm [OPTIONS]"
        echo
        echo "OPTIONS:"

        awk '/^case/,/^esac/' "$0" |
            grep -E "^\s*(#|-.*|;;)" |
            sed -E 's/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g'
        ;;
    *)
        _mpv_play "$@"
        ;;

esac
