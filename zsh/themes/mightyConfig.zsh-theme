PS1="%{$fg[green]%}%~%{$reset_color%} "

_get_branch() {
    if [ -d ".git" ]; then
        git branch --show-current
    fi
}

setopt PROMPT_SUBST
RPS1=$'$(_get_branch)'
