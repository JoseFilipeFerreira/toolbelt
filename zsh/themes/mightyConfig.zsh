PS1="%{$fg[green]%}%~%{$reset_color%} "
if [ -n "$SSH_CLIENT" ]
then
    PS1="%{$fg[yellow]%}%n@%M %{$fg[green]%}%~%{$reset_color%} "
fi

_get_branch() {
    if [ -d ".git" ]; then
        git branch --show-current
    fi
}

setopt PROMPT_SUBST
RPS1=$'$(_get_branch)'
