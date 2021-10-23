#!/bin/bash
# notify of next event and open location if there is less than 60 seconds to go

calendar="Meetings"
priority="low"

_notify(){
    notify-send \
        -u "$priority" \
        -a "in $calendar" \
        -i "$DOTFILES/assets/calendar.png" \
        "$1" \
        "$2"
}

_print_seconds(){
    secs="$1"
    [[ $secs -gt 86400 ]] && echo "in $(( secs / 86400)) days" && return
    [[ $secs -gt 3600 ]] && echo "in $(( secs / 3600)) hours" && return
    [[ $secs -gt 60 ]] && echo "in $(( secs / 60)) mins" && return
    echo "in $secs secs"
}

tmp_sep="#"

event="$(\
    khal list \
        -a "$calendar" \
        --format "{start}$tmp_sep{title}$tmp_sep{location}$tmp_sep" \
        --day-format "" |
    head -n 1)"

[[ ! "$event" ]] && _notify "Couldn't find events" "in $calendar" && exit

readarray -d"$tmp_sep" -t event_fields < <(echo "$event")

name="${event_fields[1]}"
location="${event_fields[2]}"
date_epoch="$(date --date="${event_fields[0]}" +%s)"
curr_time="$(date +%s)"
time="$(( date_epoch - curr_time ))"

[[ "$time" -lt 86400 ]] && priority="normal"
[[ "$time" -lt 300 ]] && priority="critical"

_notify \
    "$name" \
    "<b>time:</b>\n${event_fields[0]} ($(_print_seconds "$time"))\n<b>location:</b>\n$location"

[[ "$time" -gt 60 ]] && exit

case "$location" in
    http*)
        xdg-open "$location"
        ;;
esac
