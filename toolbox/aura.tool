case "$1" in
    -R*)
        pacman -Rsn "$2"
        # pacman "$1" "$2"
        ;;
    -Ss)
        curl -s "https://aur.archlinux.org/rpc/?v=5&type=search&by=name&arg=$2" \
            | jq '.results[] | "\(.Name) -> \(.Description)"'
        ;;
    -S)
        aura "$2"
        ;;
    *)
        old="$(pwd)"
        cd /tmp || exit 1
        git clone https://aur.archlinux.org/"$1"
        cd "$1" || exit 1
        makepkg -si --clean
        cd "$old" || exit 1
        rm -rf /tmp/"$1"
        ;;
esac
