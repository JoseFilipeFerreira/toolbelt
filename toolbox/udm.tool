#!/bin/bash
# playlist manager (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))
set -e

remote="kiwi"
folder=".local/share/music"

mkdir -p "$HOME/$folder"

ydl_flags=(
    --format 'bestaudio'
    --extract-audio
    --add-metadata
    --no-playlist
    --audio-format mp3
    --embed-thumbnail
    --output "$HOME/$folder/%(title)s.%(ext)s" )

mpvsocket="/tmp/mpvsocket"

update_bar(){
    pkill --signal 62 thonkbar
}

sync_music(){
    [[ "$(hostname)" == "$remote" ]] && return 0

    if ssh -q "$remote" exit
    then
        echo -e "\e[32mSyncing Music...\e[0m"
        rsync -av --delete --exclude ".config" "$remote:$folder/" "$HOME/$folder"
        echo
        return 0
    else
        echo -e "\e[31mCouldn't connect to server\e[0m"
        echo
        return 1
    fi
}

add_music(){
    case "$1" in
        --clipboard|-c)
            link="$(xclip -sel clip -o)"
            echo -n "add link ($link) [Y/n] "
            read -r
            case $REPLY in
                "y"|"Y"|"")
                    add_music "$link"
                    ;;
            esac
            return
        ;;
        http*)
            if [[ "$(hostname)" != "$remote" ]]; then
                echo -e "\e[32mDownloading on $remote...\e[0m"
                ssh "$remote" ~/.local/bin/udm --add "$@"
            else
                case "$1" in
                    *yout*)
                        youtube-dl "${ydl_flags[@]}" "$1"
                        ;;
                    *)
                        if [[ ! "$2" ]]; then
                            wget "$1" -P "$HOME/$folder"
                        else
                            wget "$1" -O "$HOME/$folder/$2"
                        fi
                        ;;
                esac
                ~/.local/bin/nospace "$HOME/$folder"/*
            fi
        ;;
        *)
            if [[ "$(hostname)" != "$remote" ]]; then
                scp "$1" "$remote":"$folder"
            else
                cp "$1" "$HOME/$folder"
            fi
        ;;
    esac
}

discord_music(){
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


mpv_play(){
    mpv --input-ipc-server="$mpvsocket" "$@"
}

mpv_control(){
    echo "$1" | socat - "$mpvsocket"
}

mpv_do(){
    mpv_control '{ "command": '"$1"' }' |
        if [[ "$2" ]]; then jq "${@:2}"; else cat; fi
}

mpv_get(){
    mpv_do '["get_property", "'"$1"'"]' "${2:-.}" "${@:3}"
}

media_control(){
    if pgrep mpv &>/dev/null; then
        mpv_control "$1"
    else
        playerctl "$2"
        update_bar
    fi
}

echo_info(){
    path="$(mpv_get "path" --raw-output .data 2>/dev/null)"

    case $path in
        http*)
            path="$(mpv_get "media-title" --raw-output .data 2>/dev/null)"
            ;;
        "")
            return
            ;;
    esac

    basename "${path%.*}" | sed -E 's/-/ - /g;s/_/ /g'
}

echo_block(){
    volume="$(mpv_get "volume" --raw-output .data 2>/dev/null)"

    path="$(echo_info)"
    [[ "$path" ]] || return

    echo "$path [$volume%]"

    echo "#FFFFFF"

    case "$(mpv_get "pause" --raw-output .data)" in
        true)  echo "#AAAAAA" ;;
        false) echo "#00EE00" ;;
    esac
}


case "$1" in
    -a|--add)
        # Add music to playlist
        # -c, --clipboard
        #     get link from clipboard
        sync_music || exit
        add_music "${@:2}"
        sync_music || exit
        ;;

    -p|--play)
        # Shuffle music from playlist
        sync_music || [ -d "$HOME/$folder" ] || exit
        mpv_play --shuffle --no-video "$HOME/$folder"
        ;;

    -s|--select)
        # Select music (uses fzf)
        sync_music || [ -d "$HOME/$folder" ] || exit
        file="$(find "$HOME/$folder"  -type f -printf "%f\n" | sort | fzf )"
        mpv_play --no-video "$HOME/$folder/$file"
        ;;
    -rm|--remove)
        # Delete music (uses fzf)
        sync_music || exit
        file="$(find "$HOME/$folder"  -type f -printf "%f\n" | sort | fzf )"

        ssh "$remote" rm -v "$folder/$file" | sed -e "s|'/|$remote:'/|g"
        rm -v "$HOME/$folder/$file"
        ;;

    --discord)
        # Play playlist on discord
        discord_music "${@:2}"
        ;;

    --stop)
        # Stop music
        media_control 'quit' 'stop'
        ;;
    --play-pause)
        # Toggle play-pause
        media_control 'cycle pause' 'play-pause'
        ;;
    --next)
        # Next music
        media_control 'playlist-next' 'next'
        ;;
    --previous|--prev)
        # Previous music
        media_control 'playlist-prev' 'previous'
        ;;

    --volume-up)
        # Increase player volume
        media_control 'add volume 5' 'volume 5+'
        ;;

    --volume-down)
        # Decrease player volume
        media_control 'add volume -5' 'volume 5-'
        ;;

    --back)
        # Seek 30 seconds backwards
        media_control 'seek -30' 'position 30-'
        ;;

    --forward)
        # Seek 30 seconds forward
        media_control 'seek 30' 'position 30+'
        ;;

    --block)
        # Block compatible with thonkbar
        echo_block
        ;;

    --info)
        # Show info on current music
        echo_info
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
        mpv_play "$@"
        ;;

esac
