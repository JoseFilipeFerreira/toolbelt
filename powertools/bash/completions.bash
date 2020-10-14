#!/bin/bash

_za() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < \
        <(compgen -o plusdirs -A file -- "$cur" | grep -P '(\.djvu|\.pdf)$')
    return
}

complete -F _za za

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

complete -F _ssh ssh

_cd() {
    case "$2" in
        \$*/*)
            mapfile -t COMPREPLY < <(compgen -d "$(eval "echo ${2%%/*}")/${2#*/}")
            ;;
        *)
            local vars
            vars="$(compgen -e | while read -r v; do
                eval "test -d \"\$$v\"" && echo "\\\$$v/"
            done)"
            mapfile -t COMPREPLY < <(compgen -d -W "$vars" -- "$2")
            ;;
    esac
}

complete -F _cd cd
