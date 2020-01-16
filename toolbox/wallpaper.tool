set -e
addWall() {
    cd $WALLS
    case $2 in
        "")
            wget $1
            ;;
        *)
            wget $1 -O $2
            ;;
    esac
    rsync -av $WALLS/ jff.sh:~/wallpapers
}

rmWall() {
    wall=$(sxiv -to $WALLS)
    for w in $wall; do
        ssh jff.sh \
            "find wallpapers/ -type l,f -name '$(basename "$w")' | xargs rm -v" | sed "s/'/'jff.sh:/"
        rm -v "$w"
    done
}

if [ ! -d $WALLS ]
then
    echo -e "\033[35mDowloading Wallpapers...\033[33m"
    rsync -av jff.sh:~/wallpapers/ $WALLS
    echo -e "\033[35mDone!\033[0m"
fi

case "$1" in
    add)
        addWall ${@:2}
        ;;
    rm)
        rmWall
        ;;
    next)
        changeWall ${@:2}
        ;;
    select)
        sxiv -to $WALLS | xargs -r -n 1 changeWall
        ;;
    "")
        changeWall
        ;;
esac
