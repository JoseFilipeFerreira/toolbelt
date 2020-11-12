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
    --curr)
        _curr_line | cut -d: -f4
        ;;
    --curr-location)
        _curr_line | cut -d: -f5
        ;;
    --curr-link)
        echo "https://$(_curr_line | cut -d: -f6)"
        ;;
    --show|"")
        _display | column -t -N " ,seg,ter,qua,qui,sex" -R 1 -s "|"
        ;;
esac
