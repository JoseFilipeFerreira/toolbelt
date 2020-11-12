#!/bin/bash
_call_kiwi(){
    ssh kiwi 'echo "'"$1"'" > /tmp/meross.d'
    [[ ! "$2" ]] &&
        notify-send \
            -u low \
            -i "$DOTFILES/assets/meross.png" \
            -t 1500 \
            -a "merrosd" \
            "Attic" \
            "lights: $(ssh kiwi 'cat /tmp/merossstate.d')"
}

case "$1" in
    --toggle|--on|--off)
        _call_kiwi "${1:2}"
        ;;
    --close)
        _call_kiwi "${1:2}" --no-cat
        ;;
    *)
        echo "USAGE: meross-cli --[on|off|toggle]"
        exit
        ;;
esac
