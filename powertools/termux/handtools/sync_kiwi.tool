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
dcim/MyAlbums
dcim/Facebook
movies/Instagram
movies/Messenger
pictures/Instagram
pictures/Messenger
pictures/Reddit
)

update_notification(){
    [[ "$1" ]] && notification_content+=("$1")

    printf -v var "%s\n" "${notification_content[@]}"
    echo "$var"
    termux-notification \
        --id "$notification_id" \
        --icon cloud_sync \
        --alert-once \
        --title "$notification_title" \
        --image-path ~/.toolbelt/powertools/toolicons/512x512/devices/computer-kiwi.png \
        --content "$var"
}

update_notification "..."

notification_content=()
for folder in "${folders[@]}"; do
    if [ -d ~/storage/"$folder" ]; then
        update_notification "$folder"
        rsync "${rsync_flags[@]}" --relative ~/storage/./"$folder" "$remote":phone/
    else
        update_notification "File not found: $folder"
    fi

done

rsync_delete_flags=( --exclude '.config' --progress -av --delete )

update_notification "media/music"
rsync "${rsync_delete_flags[@]}" "$remote":.local/share/music/ ~/storage/music
termux-media-scan ~/storage/music

update_notification "wallpapers"
rsync "${rsync_delete_flags[@]}" "$remote":.local/share/wallpapers ~/.local/share

notification_title+=" Done"
update_notification
