#!/bin/bash
# notify of next event (with action to open it)

calendar="Meetings"
priority="low"


_notify(){
    dunstify \
        -u "$priority" \
        -a "in $calendar" \
        -i "apps/calendar" \
        "$@"
}

# get next event
tmp_sep="^"
event="$(\
    khal list \
        -a "$calendar" \
        --format "{start}$tmp_sep{title}$tmp_sep{location}$tmp_sep" \
        --day-format "" |
    head -n 1)"

[[ ! "$event" ]] &&
    _notify "Couldn't find events" "in $calendar" &&
    exit

readarray -d"$tmp_sep" -t event_fields < <(echo "$event")

start=${event_fields[0]}
title="${event_fields[1]}"
location="${event_fields[2]}"

# calculate time to event
date_epoch="$(date --date="$start" +%s)"
curr_time="$(date +%s)"
time="$(( date_epoch - curr_time ))"

# print time to event and calulate urgency
time_left="$(printf 'in %dd %02dh%02dm' $((time/86400)) $((time%86400/3600)) $((time%3600/60)))"

[[ "$time" -lt 86400 ]] &&
    priority="normal" &&
    time_left="$(printf 'in %02dh%02dm' $((time/3600)) $((time%3600/60)))"

[[ "$time" -lt 3600 ]] &&
    priority="critical" &&
    time_left="$(printf 'in %02dm' $((time/60)))"

body="<b>time:</b>\n$start ($time_left)\n"

actions=()
case "$location" in
    http*)
        body+="<b>location:</b>\nas link"
        actions+=( --action="open, $location")
        ;;
    *)

        readarray -t installed_apps < <(compgen -c)
        if [[ " ${installed_apps[*]} " =~ " ${location} " ]]; then
            body+="<b>app:</b>\n$location"
            actions+=( --action="launch, $location")
        else
            body+="<b>location:</b>\n$location"
            actions+=( --action="search, google")
            [ "$(echo "$location" | wc -w)" -gt 1 ] &&
                actions+=( --action="location, google maps")
        fi
        ;;
esac


action="$( _notify "$title" "$body" "${actions[@]}")"

[ "$action" ] || exit

case "$action" in
    launch)
        "$location" & disown
        ;;
    open)
        xdg-open "$location"
        ;;
    search)
        xdg-open "https://www.google.com/search?q=${location// /\+}"
        ;;
    location)
        xdg-open "https://www.google.com/maps/place/${location// /\+}"
        ;;
esac
