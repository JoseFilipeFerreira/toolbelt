PS1="%{$fg[green]%}%~%{$reset_color%} "

if [ -n "$SSH_CLIENT" ]
then
    PS1="%{$fg[yellow]%}%n@%M %{$fg[green]%}%~%{$reset_color%} "
    export TERM=xterm
    if [ -z "$TMUX" ]; then
        exit() {
            tmux -2 detach
        }
        tmux -2 a &>/dev/null || tmux -2
    fi
fi

_git_branch() {
    if [[ -d .git ]] || [[ -d ../.git ]] || [[ -d ../../.git ]]  ; then
        git symbolic-ref HEAD --short
    fi
}

setopt PROMPT_SUBST
RPS1=$'$(_git_branch)'
