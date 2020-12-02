#!/bin/bash
# weekly calendar from a [CSV](toolbox/.timetable)

_curr_line(){
    awk \
        -F: \
        -v d="$(date +%u)" \
        -v h="$(date +%H)" \
        'd == $1 && h >= $2 && h < $3 {print $0}' \
    "$DOTFILES""/toolbox/.timetable"
}

_next_line(){

    next_event="$(awk \
            -F: \
            -v d="$(date +%u)" \
            -v h="$(date +%H)" \
            'd < $1 || ( d == $1 && h < $2) {print $0; exit}' \
            "$DOTFILES/toolbox/.timetable")"

    if [[ ! $next_event ]]
    then
        head -1 "$DOTFILES/toolbox/.timetable"
    else
        echo "$next_event"
    fi
}

_display(){
    for h in {8..19}
    do
        echo -n "$h""h|"
        for d in {1..5}; do
            awk \
                -F: \
                -v d="$d" \
                -v h="$h" \
                '{ if(d == $1 && h >= $2 && h < $3){printf "%s-%s", $4, $5;} }' \
            "$DOTFILES""/toolbox/.timetable"
            echo -en "|"
        done
        echo ""
    done
}

case "$1" in
    --test)
        _next_line
        ;;
    --curr)
        _curr_line | cut -d: -f4
        ;;
    --curr-location)
        _curr_line | cut -d: -f5
        ;;
    --curr-link)
        echo "https://$(_curr_line | cut -d: -f6)"
        ;;
    --next)
        _next_line | cut -d: -f4
        ;;
    --next-location)
        _next_line | cut -d: -f5
        ;;
    --next-link)
        echo "https://$(_next_line | cut -d: -f6)"
        ;;
    --show|"")
        _display | column -t -N " ,seg,ter,qua,qui,sex" -R 1 -s "|"
        ;;
    *)
        echo -e "calendar --[curr|next]\ncalendar --[curr|next]-[location|link]\ncalendar --show"
esac
