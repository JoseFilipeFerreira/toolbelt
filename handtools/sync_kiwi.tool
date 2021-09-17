#!/data/data/com.termux/files/usr/bin/bash
# sync phone data with remote

set -e

notification_id="$RANDOM"
notification_title="Syncing jff.sh"
notification_content=()

remote="mightymime@jff.sh"
if ping -c 1 kiwi &>/dev/null; then
    remote="mightymime@kiwi"
    notification_title="Syncing kiwi"
fi

rsync_flags=( --progress --recursive --perms --times --owner --group --devices --specials --copy-links --verbose)

folders=(
dcim/Camera
dcim/Facebook
movies/Instagram
movies/Messenger
pictures/Instagram
pictures/Messenger
pictures/MyCollections
pictures/Reddit
)

_update_notification(){
    [[ "$1" ]] && notification_content+=("$1")

    printf -v var "%s\n" "${notification_content[@]}"
    echo "$var"
    termux-notification \
        --id "$notification_id" \
        --alert-once \
        --title "$notification_title" \
        --image-path ~/shortcuts/assets/kiwi.png \
        --content "$var"
}

_update_notification "..."

notification_content=()
for folder in "${folders[@]}"; do
    if [ -d ~/storage/"$folder" ]; then
        _update_notification "$folder"
        rsync "${rsync_flags[@]}" --relative ~/storage/./"$folder" "$remote":phone/
    else
        _update_notification "File not found: $folder"
    fi

done

rsync_delete_flags=( --exclude '.config' --progress -av --delete )

_update_notification "media/music"
rsync "${rsync_delete_flags[@]}" "$remote":.local/share/music/ ~/storage/music
termux-media-scan ~/storage/music

_update_notification "wallpapers"
rsync "${rsync_delete_flags[@]}" "$remote":.local/share/wallpapers ~/.local/share

notification_title+=" Done"
_update_notification