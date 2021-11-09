#!/bin/bash
# playlist manager (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))
set -e

remote="kiwi"
remote_location=".local/share/music"
local_location="$HOME/.local/share/music"

mkdir -p "$local_location"

ydl_flags=(
    --format 'bestaudio'
    --extract-audio
    --add-metadata
    --no-playlist
    --audio-format mp3
    --embed-thumbnail
    --output "$local_location/%(title)s.%(ext)s" )

mpvsocket="/tmp/mpvsocket"

_update_bar(){
    pkill --signal 62 thonkbar
}

_sync_music() {
    [[ "$(hostname)" == "$remote" ]] && return 0

    if ssh -q "$remote" exit
    then
        echo -e "\e[32mSyncing Music...\e[0m"
        rsync -av --delete --exclude ".config" "$remote:$remote_location/" "$local_location"
        echo
        return 0
    else
        echo -e "\e[31mCouldn't connect to server\e[0m"
        echo
        return 1
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
                    _add_music  "$link"
                    ;;
            esac
            return
        ;;
        http*yout*)
            youtube-dl "${ydl_flags[@]}" "$1"
        ;;
        http*)
            if [[ ! "$2" ]]; then
                wget "$1" -P "$local_location"
            else
                wget "$1" -O "$local_location/$2"
            fi
        ;;
        *)
            cp "$1" "$local_location"
        ;;
    esac
    nospace "$local_location"/*
    [[ "$(hostname)" == "$remote" ]] || \
        rsync -av "$local_location"/ "$remote":"$remote_location"
}

_discord_music() {
    prefix="."
    [[ $1 ]] && prefix="$1"
    echo "prefix: $prefix"

    website="https://jff.sh/music"
    music_link=$(curl "$website" | grep '<a' | cut -d"'" -f2 | shuf | nl)
    n_lines="$(echo "$music_link" | wc -l)"

    sleep 3

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

_echo_info(){
    path="$(_mpv_get "path" --raw-output .data 2>/dev/null)"

    case $path in
        http*)
            path="$(_mpv_get "media-title" --raw-output .data 2>/dev/null)"
            ;;
        "")
            return
            ;;
    esac

    basename "${path%.*}" | sed -E 's/-/ - /g;s/_/ /g'
}

_echo_block(){
    volume="$(_mpv_get "volume" --raw-output .data 2>/dev/null)"

    path="$(_echo_info)"
    [[ "$path" ]] || return

    echo "$path [$volume%]"

    echo "#FFFFFF"

    case "$(_mpv_get "pause" --raw-output .data)" in
        true)  echo "#AAAAAA" ;;
        false) echo "#00EE00" ;;
    esac
}


case "$1" in
    -a|--add)
        # Add music to playlist
        # -c, --clipboard
        #     get link from clipboard
        _sync_music || exit
        _add_music "${@:2}"
        ;;

    -p|--play)
        # Shuffle music from playlist
        _sync_music || [ -d "$local_location" ] || exit
        _mpv_play --shuffle --no-video "$local_location"
        ;;

    -s|--select)
        # Select music (uses fzf)
        _sync_music || [ -d "$local_location" ] || exit
        file="$(find "$local_location"  -type f -printf "%f\n" | sort | fzf )"
        _mpv_play --no-video "$local_location/$file"
        ;;
    -rm|--remove)
        # Delete music (uses fzf)
        _sync_music || exit
        file="$(find "$local_location"  -type f -printf "%f\n" | sort | fzf )"

        ssh "$remote" rm -v "$remote_location/$file" | sed -e "s|'/|$remote:'/|g"
        rm -v "$local_location/$file"
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

    --volume-up)
        # Increase player volume
        _media_control 'add volume 5' 'volume 5+'
        ;;

    --volume-down)
        # Decrease player volume
        _media_control 'add volume -5' 'volume 5-'
        ;;

    --back)
        # Seek 30 seconds backwards
        _media_control 'seek -30' 'position 30-'
        ;;

    --forward)
        # Seek 30 seconds forward
        _media_control 'seek 30' 'position 30+'
        ;;

    --block)
        # Block compatible with thonkbar
        _echo_block
        ;;

    --info)
        # Show info on current music
        _echo_info
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
