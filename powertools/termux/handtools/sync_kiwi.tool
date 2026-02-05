#!/data/data/com.termux/files/usr/bin/bash
# sync phone data with remote

set -e

notification_id="$RANDOM"
notification_title="Syncing jff.sh"
notification_content=()

remote="jff@jff.sh"
if ping -c 1 kiwi &>/dev/null; then
    remote="jff@kiwi"
    notification_title="Syncing kiwi"
fi

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

rsync_delete_flags=( --exclude '.config' --progress -aO --delete)

update_notification "media/music"
rsync "${rsync_delete_flags[@]}" "$remote":.local/share/music/ ~/storage/music/
termux-media-scan ~/storage/music

update_notification "wallpapers"
rsync "${rsync_delete_flags[@]}" "$remote":.local/share/wallpapers/ ~/storage/pictures/wallpapers
termux-media-scan ~/storage/pictures/wallpapers

notification_title+=" Done"
update_notification
