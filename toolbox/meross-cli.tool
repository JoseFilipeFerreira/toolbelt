#!/bin/bash
_call_kiwi(){
    ssh kiwi 'echo "'"$1"'" > /tmp/meross.d'
    [[ ! "$2" ]] &&
        notify-send \
            --urgency=low \
            --icon="$DOTFILES/assets/meross.png" \
            --expire-time=1500 \
            "merrosd" \
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
