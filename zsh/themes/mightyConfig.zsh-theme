PROMPT="%{$fg[green]%}%~%{$reset_color%} "

# Load version control information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
    vcs_info
}

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:*' formats '%b'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
RPROMPT='${vcs_info_msg_0_}'
