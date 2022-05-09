#!/bin/bash
# notify of next event (with action to open it)

calendar="Meetings"

priority="normal"

notify(){
    dunstify \
        -u "$priority" \
        -a "in $calendar" \
        -i "apps/calendar" \
        "$@"
}

seconds_left(){
    local epoch
    epoch="$(date --date="$1" +%s)"
    local now
    now="$(date +%s)"
    echo "$(( epoch - now ))"
}

print_time_left(){
    time="$(seconds_left "$1")"

    [[ "$time" -lt 3600 ]] &&
        printf 'in %02dm' $((time/60)) &&
        return

    [[ "$time" -lt 86400 ]] &&
        printf 'in %02dh%02dm' $((time/3600)) $((time%3600/60)) &&
        return

    printf 'in %dd %02dh%02dm' $((time/86400)) $((time%86400/3600)) $((time%3600/60))
}

readarray -t installed_apps < <(compgen -c)

readarray -t events < <(\
    khal list \
        -a "$calendar" \
        --format "{start}{tab}{end}{tab}{title}{tab}{location}" \
        --day-format "")

[[ "${#events[@]}" -eq 0 ]] &&
    notify "Couldn't find events" &&
    exit

for event in "${events[@]}"; do
    readarray -d $'\t' -t event_fields < <(echo "$event")

    start=${event_fields[0]}
    end=${event_fields[1]}
    title="${event_fields[2]}"
    location="${event_fields[3]}"

    # check if event is already over
    end_secs="$(seconds_left "$end")"
    [ "$end_secs" -lt 0 ] && continue

    body="<b>time:</b>\n$start ($(print_time_left "$start"))\n"

    actions=()
    case "$location" in
        http*)
            body+="<b>location:</b>\nas link"
            actions+=( "--action=open, $location")
            ;;
        $'\n')
            ;;
        *)
            # shellcheck disable=SC2076
            if [[ " ${installed_apps[*]} " =~ " ${location} " ]]; then
                body+="<b>app:</b>\n$location"
                actions+=( "--action=launch, $location")
            else
                body+="<b>location:</b>\n$location"
                actions+=( "--action=search, google")
                [ "$(echo "$location" | wc -w)" -gt 1 ] &&
                    actions+=( "--action=location, google maps")
            fi
            ;;
    esac

    action="$( notify "$title" "$body" "${actions[@]}")"

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

    exit
done
