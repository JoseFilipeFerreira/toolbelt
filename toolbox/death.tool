#!/bin/bash
# warn if all batteries are bellow a certain percent

min_percent=10

_has_charge(){
    while read percent; do
        [[ "$percent" -gt "$min_percent" ]] && return 0
    done < <(acpi -b | cut -d, -f2 | sed 's/[ %]//g')
}

warn_file="/tmp/.death_warned"

while :; do
    if _has_charge; then
        [ -f "$warn_file" ] && rm "$warn_file"
    else
        [ -f "$warn_file" ] && exit

        touch "$warn_file"

        notify-send \
            -u "critical" \
            -i "status/battery-low" \
            -a death \
            "low battery" \
            "bellow $min_percent%"
    fi
    sleep 1m
done
