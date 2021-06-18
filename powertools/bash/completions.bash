#!/bin/bash
command -V gh &>/dev/null &&
    . <(gh completion -s bash)

_ssh() {
    local opts
    # local prev
    local cur="${COMP_WORDS[COMP_CWORD]}"
    #prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null |
        grep -v '[?*]' |
        cut -d ' ' -f 2-)
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return 0
}

_za() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < \
        <(compgen -o plusdirs -A file -- "$cur" | grep -P '(\.djvu|\.pdf)$')
    return
}

_gcl() {
    local CWORD=${COMP_WORDS[COMP_CWORD]}
    local IFS=$'\n'

    local user="$(git config user.name)"
    [[ "$CWORD" == */* ]] &&
        user="$(echo "$CWORD" | cut -d/ -f1)"

    repos="$(gh repo list "$user" \
        --limit=100 \
        --json nameWithOwner \
        --jq=".[].nameWithOwner")"

    [[ "$CWORD" == */* ]] ||
        repos="$(echo "$repos" | sed "s/$user\///g")"

    COMPREPLY=( $(compgen -W "$repos" -- "$CWORD") )
}

command -V gh &> /dev/null &&
    complete -F _gcl gcl

complete -d cd
complete -F _ssh ssh
complete -F _za za

