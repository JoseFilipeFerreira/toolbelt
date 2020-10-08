#!/bin/bash
WORKOUTS="$XDG_DATA_HOME/workin"

mkdir -p "$WORKOUTS"

AVAILABLE_WORKOUTS="$(find "$WORKOUTS" -type f -exec basename {} \;)"

get_number(){
    local VAR
    while :; do
        read -rp "Insert $1: " VAR
        if [ -n "$VAR" ] && [ "$VAR" -eq "$VAR" ] 2>/dev/null; then
            NUMBER="$VAR"
            break
        else
            echo "Invalid number"
        fi
    done
}

get_time(){
    local VAR
    while :; do
        read -rp "Insert $1 (dd/mm/yy hh:mm) [Curr|custom]: " VAR

        if [[ -z "$VAR" || "$VAR" == "Curr" ]]; then
            TIME="$(date +'%d/%m/%y %R')"
            break
        else
            if [[ "$VAR" = $(date -d "$VAR" +'%d/%m/%y %R') ]]; then 
                TIME="$date"
                break
            else
                echo "Invalid date format"
            fi
        fi
    done
}

ask_workout_data(){
    local FIELDS
    IFS=','  read -ra FIELDS < <(sed 1q "$WORKOUTS/$SELECTED")

    local VALUES=()
    for FIELD in "${FIELDS[@]}"; do
        case "$FIELD" in
            endtime)
                get_time "$FIELD"
                VALUES+=("$TIME")
                ;;
            duration)
                get_number "$FIELD (min)"
                VALUES+=("$NUMBER")
                ;;
            distance|calories|count)
                get_number "$FIELD"
                VALUES+=("$NUMBER")
                ;;
            *)
                echo "Unknown field \"$FIELD\" in file: $WORKOUTS/$SELECTED"
                exit
                ;;
        esac
    done

    if [ -n "$VALUES" ]; then
        printf -v joined '%s,' "${VALUES[@]}"
        echo "${joined%,}" >> "$WORKOUTS/$SELECTED"
    fi
}

select SELECTED in $AVAILABLE_WORKOUTS
do
    [ -z "$SELECTED" ] && echo "Invalid Workout" && break

    ask_workout_data "$SELECTED"

    break
done
