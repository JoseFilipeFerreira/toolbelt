#!/bin/bash
curr_class(){
    awk -F: 'BEGIN { d='"$(date +%u)"' ;h='"$(date +%H)"' } d == $1 && h >= $2 && h < $3 {print $4}' \
        "$DOTFILES""/toolbox/.timetable"
}

curr_location(){
    awk -F: 'BEGIN { d='"$(date +%u)"' ;h='"$(date +%H)"' } d == $1 && h >= $2 && h < $3 {print $5}' \
        "$DOTFILES""/toolbox/.timetable"
}

next_class(){
    awk -F: 'BEGIN { d='"$(date +%u)"' ;h='"$(date +%H)"' } d == $1 && h < $2 {print $4; exit}' \
        "$DOTFILES""/toolbox/.timetable"
}

next_location(){
    awk -F: 'BEGIN { d='"$(date +%u)"' ;h='"$(date +%H)"' } d == $1 && h < $2 {print $5; exit}' \
        "$DOTFILES""/toolbox/.timetable"
}

display(){
    for h in {9..19}
    do
        echo -n ""$h"h|"
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
        curr_class
        ;;
    --curr-location)
        curr_location
        ;;
    --next)
        next_class
        ;;
    --next-location)
        next_location
        ;;
    --show|"")
        display | column -t -N " ,seg,ter,qua,qui,sex" -R 1 -s "|"
        ;;
esac
