#!/bin/bash

if [ -n "$SSH_CLIENT" ]; then

    export TERM=xterm

    if [ -z "$TMUX" ] && command -v tmux &>/dev/null ; then
        read -p 'Launch tmux? [Y/n]' -r
        case $REPLY in
            "y"|"Y"|"")
                exit() {
                    tmux -2 detach
                }
                tmux -2 a &>/dev/null || tmux -2
                exit
                ;;
        esac
        unset REPLY
    fi
fi
