#!/bin/bash
_ssh(){
    mapfile -t COMPREPLY < \
        <(compgen -W \
            "$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null |
                grep -v '[?*]' |
                cut -d ' ' -f 2- \
            )" -- "$2")
}
complete -F _ssh ssh

_za(){
    mapfile -t COMPREPLY < \
        <(compgen -o plusdirs -A file -- "$2" | grep -P '(\.djvu|\.pdf)$')
}
complete -F _za za

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

complete -d cd
