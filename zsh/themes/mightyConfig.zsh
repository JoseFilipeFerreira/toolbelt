PS1="%{$fg[green]%}%~%{$reset_color%} "
if [ -n "$SSH_CLIENT" ]
then
    PS1="%{$fg[yellow]%}%n@%M %{$fg[green]%}%~%{$reset_color%} "
    export TERM=xterm
fi

_get_branch() {
    if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
        git branch --show-current
    fi
}

setopt PROMPT_SUBST
RPS1=$'$(_get_branch)'
