#!/data/data/com.termux/files/usr/bin/bash
# control music on a remote device

case "$2" in
    --stop|--next|--previous|--back|--forward|--play-pause)
        result="$(ssh "$1" '.local/bin/udm '"$2"' && .local/bin/udm --info')"
        if [[ "$result" ]]; then
            termux-toast -s -g top "$result"
        else
            termux-toast -s -g top "No music playing"
        fi
        ;;
    \+|-|mute)
        ssh "$1" '.local/bin/deaf '"$2"'&& .local/bin/deaf --info' | termux-toast -s -g top
        ;;
    *)
        echo "Invalid command"
        ;;
esac
