#!/bin/bash
# control meross lights (integrates with [merossd](https://github.com/JoseFilipeFerreira/merossd))

case "$1" in
    --toggle|--on|--off)
        if [[ "$(hostname)" == "kiwi" ]]
        then
            status="$(curl --silent localhost:4200/bulb/"${1:2}")"
        else
            status="$(ssh kiwi 'curl --silent localhost:4200/bulb/'"${1:2}"'')"
        fi
        notify-send \
            -u low \
            -i "apps/meross" \
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
