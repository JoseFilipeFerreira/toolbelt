#!/bin/bash
workouts="$XDG_DATA_HOME/workin"

mkdir -p "$workouts"

available_workouts="$(find "$workouts" -type f -exec basename {} \;)"

get_number(){
    while :; do
        read -rp "Insert $1: "
        if [[ "$REPLY" ]] && [ "$REPLY" -eq "$REPLY" ] 2>/dev/null; then
            number="$REPLY"
            break
        else
            echo "Invalid number"
        fi
    done
}

get_time(){
    while :; do
        read -rp "Insert $1 [Curr|dd/mm/yy hh:mm]: "

        if [[ -z "$REPLY" || "$REPLY" == "Curr" ]]; then
            TIME="$(date +'%d/%m/%y %R')"
            break
        else
            if [[ "$REPLY" = "$(date -d "$REPLY" +'%d/%m/%y %R')" ]]; then 
                TIME="$REPLY"
                break
            else
                echo "Invalid date format"
            fi
        fi
    done
}

ask_workout_data(){
    local fields
    IFS=','  read -ra fields < <(sed 1q "$workouts/$selected")

    local values=()
    for field in "${fields[@]}"; do
        case "$field" in
            endtime)
                get_time "$field"
                values+=("$TIME")
                ;;
            duration)
                get_number "$field (min)"
                values+=("$number")
                ;;
            distance|calories|count)
                get_number "$field"
                values+=("$number")
                ;;
            *)
                echo "Unknown field \"$field\" in file: $workouts/$selected"
                exit 1
                ;;
        esac
    done

    if (( ${#values[@]} )); then
        printf -v joined '%s,' "${values[@]}"
        echo "${joined%,}" >> "$workouts/$selected"
    fi
}

select selected in $available_workouts
do
    [[ "$selected" ]] || echo "Invalid Workout" && break

    ask_workout_data "$selected"

    break
done
