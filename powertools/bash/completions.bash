#!/bin/bash

# Use bash-completion, if available
# shellcheck disable=SC1091
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

_gcl(){
    local IFS=$'\n'

    local user
    user="$(git config user.name)"
    [[ "$2" == */* ]] &&
        user="$(echo "$2" | cut -d/ -f1)"

    repos="$(gh repo list "$user" \
        --limit=100 \
        --json nameWithOwner \
        --jq=".[].nameWithOwner")"

    [[ "$2" == */* ]] ||
        repos="$(echo "$repos" | sed "s/$user\///g")"

    mapfile -t COMPREPLY < <(compgen -W "$repos" -- "$2")
}

# shellcheck disable=SC1090
hash gh &> /dev/null &&
    . <(gh completion -s bash) &&
    complete -F _gcl gcl

# shellcheck disable=SC1090
hash labib &> /dev/null &&
    . <(labib --completion)

# shellcheck disable=SC1090
hash icons &> /dev/null &&
    . <(icons --completion)
