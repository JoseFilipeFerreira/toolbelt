#!/bin/bash
set -e
addWall() {
    case "$1" in
        http*)
            if [ "$2" = "" ]; then
                wget "$1" -P "$WALLS"
                file="$(basename "$1")"
            else
                wget "$1" -O "$WALLS/$2"
                file="$2"
            fi
        ;;
        *)
            cp -v "$1" "$WALLS" 
            file="$(basename "$1")"
        ;;
    esac

    cd "$WALLS"

    res="$(convert "$file" -format '%[w]' info:)"
    if [ "$(echo "$res" | awk '$0 >= 1920 {print("true")}')" = true ]
    then
        rsync -av "$WALLS"/ kiwi:~/wallpapers
    else
        rm "$file"
        echo -e "\033[31mImage too small\033[0m\nonly $res"
    fi

}

rmWall() {
    wall=$(sxiv -to "$WALLS")
    for w in $wall; do
        ssh jff.sh \
            "find wallpapers/ -type l,f -name '$(basename "$w")' | xargs rm -v" | sed "s/'/'jff.sh:/"
        rm -v "$w"
    done
}

if [ ! -d "$WALLS" ]
then
    echo -e "\033[35mDowloading Wallpapers...\033[33m"
    rsync -av kiwi:~/wallpapers/ "$WALLS"
    echo -e "\033[35mDone!\033[0m"
fi

changeWall(){
    if [ -n "$1" ]
    then
        file=$1
    else
        file=$(find "$WALLS" | shuf -n 1)
    fi
    feh --no-fehbg --bg-fill "$file"
    echo "$file"
}

case "$1" in
    add)
        addWall "${@:2}"
        ;;
    rm)
        rmWall
        ;;
    next)
        changeWall "${@:2}"
        ;;
    select)
        FILE="$(sxiv -to "$WALLS")"
        [[ "$FILE" ]] || exit
        changeWall "$FILE"
        ;;
    *)
        changeWall "${@:1}"
        ;;
esac
