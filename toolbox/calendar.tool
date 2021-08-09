#!/bin/bash
# weekly calendar with current and next event search (more info with `calendar --help`)

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

    if [[ ! $next_event ]]; then
        head -1 "$DOTFILES/toolbox/.timetable"
    else
        echo "$next_event"
    fi
}

_display(){
    for h in {8..19}; do
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
        echo
    done
}

case "$1" in
    --current)
        # get current event's name
        _curr_line | cut -d: -f4
        ;;
    --current-location)
        # get current event's location
        _curr_line | cut -d: -f5
        ;;
    --current-link)
        # get current event's link
        echo "https://$(_curr_line | cut -d: -f6)"
        ;;
    --next)
        # get next event's name
        _next_line | cut -d: -f4
        ;;
    --next-location)
        # get next event's location
        _next_line | cut -d: -f5
        ;;
    --next-link)
        # get next event's link
        echo "https://$(_next_line | cut -d: -f6)"
        ;;
    --show|"")
        # display weekly timetable [Default]
        _display | column -t -N " ,seg,ter,qua,qui,sex" -R 1 -s "|"
        ;;
    -h|--help)
        # Send this help message
        echo "NAME:"
        echo "    calendar - weekly timetable manager"
        echo
        echo "USAGE:"
        echo "    calendar OPTION"
        echo
        echo "OPTION:"

        awk '/^case/,/^esac/' "$0" |
            grep -E "^\s*(#|-.*|;;)" |
            sed -E 's/\|/, /g;s/(\)$)//g;s/# //g;s/;;//g;s/, ""//g'
        echo
        echo "FILES:"
        echo "    \$DOTFILES/toolbox/.timetable"
        echo "         CSV with weekly events that follow the following format:"
        echo "         DAY:START:END:NAME:LOCATION:LINK"
        ;;

esac
