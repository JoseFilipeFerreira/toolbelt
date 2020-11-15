#!/bin/bash
# control meross lights (integrates with [merossd](https://github.com/JoseFilipeFerreira/merossd))

case "$1" in
    --toggle|--on|--off)
        status="$(ssh kiwi 'curl --silent localhost:4200/bulb/'"${1:2}"'')"
        notify-send \
            -u low \
            -i "$DOTFILES/assets/meross.png" \
            -t 1500 \
            -a "merrosd" \
            "Attic" \
            "lights: $status"
        ;;
    *)
        echo "USAGE: meross-cli --[on|off|toggle]"
        exit
        ;;
esac
