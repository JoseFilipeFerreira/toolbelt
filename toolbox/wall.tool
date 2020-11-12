#!/bin/bash
# wallpaper manager

set -e
_add_wall() {
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

_rm_wall() {
    wall=$(sxiv -to "$WALLS")
    for w in $wall; do
        ssh jff.sh \
            "find wallpapers/ -type l,f -name '$(basename "$w")' | xargs rm -v" | sed "s/'/'jff.sh:/"
        rm -v "$w"
    done
}

_change_wall(){
    if [ -n "$1" ]
    then
        file=$1
    else
        file=$(find "$WALLS" | shuf -n 1)
    fi
    feh --no-fehbg --bg-fill "$file"
    echo "$file"
}

if [ ! -d "$WALLS" ]
then
    echo -e "\033[35mDowloading Wallpapers...\033[33m"
    rsync -av kiwi:~/wallpapers/ "$WALLS"
    echo -e "\033[35mDone!\033[0m"
fi

case "$1" in
    add)
        _add_wall "${@:2}"
        ;;
    rm)
        _rm_wall
        ;;
    next)
        _change_wall "${@:2}"
        ;;
    select)
        file="$(sxiv -to "$WALLS")"
        [[ "$file" ]] || exit
        _change_wall "$file"
        ;;
    *)
        _change_wall "${@:1}"
        ;;
esac
