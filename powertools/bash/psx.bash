#!/bin/bash
RED="\033[31m"
BOLD_RED="\033[1;31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
OFF="\033[0m"

__c() {
    local NO_COLOUR="\e[00m"
    local PRINTING_OFF="\["
    local PRINTING_ON="\]"
    printf "%s%s%s%s%s%s%s" \
        "$PRINTING_OFF" "$1" "$PRINTING_ON" "$2" "$PRINTING_OFF" "$OFF" "$PRINTING_ON"
}

__stopped_jobs_status() {
    case "$(jobs | grep -c 'Stopped')" in
        0)
            ;;
        1)
            printf .
            ;;
        *)
            printf !
            ;;
    esac
}

PS1_ELEMENTS=()

[[ "$SSH_CLIENT" ]] && PS1_ELEMENTS+=("$(__c "$YELLOW" "\u@\h")")

PS1_ELEMENTS+=("$(__c "$GREEN" "\w")")

PS1_ELEMENTS+=("$(__c "$BOLD_RED" "\$(__stopped_jobs_status)")")


PS1=$(
    IFS=
    echo "${PS1_ELEMENTS[*]} "
)

export PS1
