share() {
    FILE="$1"
    if [ -d "$FILE" ]
    then
        zip -r "/tmp/$(basename "$FILE").zip" "$FILE"
        FILE="/tmp/$(basename "$FILE").zip"
    fi
    scp "$FILE" cake:~/share
    url="http://jff.sh/share/$(basename "$FILE")"
    echo "$url" | xclip -sel clip
    echo "$url"
}
