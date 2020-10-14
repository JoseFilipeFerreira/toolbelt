#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
OFF="\033[0m"

PS1_ELEMENTS=()

[ -n "$SSH_CLIENT" ] && PS1_ELEMENTS+=("$YELLOW\u@\h")

PS1_ELEMENTS+=("$GREEN\w$OFF ")

PS1=$(
    IFS=
    echo "${PS1_ELEMENTS[*]}"
)

export PS1
