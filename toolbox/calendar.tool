#!/bin/bash
_curr_line(){
    awk -F: 'BEGIN { d='"$(date +%u)"' ;h='"$(date +%H)"' } d == $1 && h >= $2 && h < $3 {print $0}' \
        "$DOTFILES""/toolbox/.timetable"
}

display(){
    for h in {9..19}
    do
        echo -n "$h""h|"
        for d in {1..5}
        do
            awk -F: 'BEGIN { d='"$d"' ;h='"$h"' } d == $1 && h >= $2 && h < $3 {printf "%s-%s", $4, $5}' \
                "$DOTFILES""/toolbox/.timetable"
            echo -n "|"
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
        echo "https://elearning.uminho.pt/webapps/collab-ultra/tool/collabultra?course_id=$(_curr_line | cut -d: -f6)"
        ;;
    --show|"")
        display | column -t -N " ,seg,ter,qua,qui,sex" -R 1 -s "|"
        ;;
esac
