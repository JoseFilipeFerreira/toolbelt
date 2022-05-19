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

socket_folder="/tmp/$USER/udm"
mkdir -p "$socket_folder"

current_socket_numbers(){
    # shellcheck disable=SC2009
    ps -fu "$LOGNAME" |
        grep -v grep |
        grep -oP 'mpvsocket([0-9])' |
        sed -E 's/mpvsocket([0-9])/\1/' |
        sort -V |
        uniq
}

current_socket_number="$(current_socket_numbers | tail -1)"
current_socket="$socket_folder/mpvsocket$current_socket_number"

next_socket(){
    local curr
    curr="$(current_socket_numbers | tail -1)"
    if [[ "$curr" ]]; then
        echo "$socket_folder/mpvsocket$(( curr + 1 ))"
    else
        echo "$socket_folder/mpvsocket0"
    fi
}

update_bar(){
    pgrep -x "thonkbar" > /dev/null &&
        pkill --signal 62 thonkbar
}

sync_music(){
    [[ "$(hostname)" == "$remote" ]] && return 0

    if ssh -q "$remote" exit; then
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
            local link
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
                        if hash yt-dlp &> /dev/null; then
                            echo "using yt-dlp"
                            yt-dlp "${ydl_flags[@]}" "$1"
                        elif hash youtube-dl &> /dev/null; then
                            echo "using youtube-dl"
                            youtube-dl "${ydl_flags[@]}" "$1"
                        else
                            echo "No download tool installed"
                            exit
                        fi
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

mpv_play(){
    [[ "$current_socket_number" ]] && udm --pause
    mpv --input-ipc-server="$(next_socket)" "$@"
}

mpv_control(){
    echo "$2" | socat - "$1"
}

mpv_get(){
    mpv_control "$1" "{ \"command\": [\"get_property\", \"$2\"]}" |
        jq --raw-output .data 2>/dev/null
}

media_control(){
    if pgrep mpv &>/dev/null; then
        mpv_control "$current_socket" "$1"
    else
        playerctl "$2"
        update_bar
    fi
}

echo_info(){
    local n_socket
    for n_socket in $(current_socket_numbers); do
        local socket
        socket="$socket_folder/mpvsocket${n_socket}"

        path="$(mpv_get "$socket" "path")"

        case $path in
            http*)
                path="$(mpv_get "$socket" "media-title")"
                ;;
            "")
                return
                ;;
        esac

        name="$(basename "${path%.*}" | sed -E 's/-/ - /g;s/_/ /g')"

        echo "$n_socket: $name"
    done
}

echo_block(){
    local volume
    volume="$(mpv_get "$current_socket" "volume")"

    local path
    path="$(echo_info | tail -1)"
    [[ "$path" ]] || return

    echo "$path [$volume%]"

    echo "#FFFFFF"

    case "$(mpv_get "$current_socket" "pause")" in
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
    --stop)
        # Stop music
        media_control 'quit' 'stop'
        ;;
    --resume)
        # Play media
        media_control 'set pause no' 'play'
        ;;
    --pause)
        # Pause media
        media_control 'set pause yes' 'pause'
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
