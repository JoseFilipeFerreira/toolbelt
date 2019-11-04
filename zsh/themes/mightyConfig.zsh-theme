_fishy_collapsed_wd() {
  echo $(pwd | perl -pe '
   BEGIN {
      binmode STDIN,  ":encoding(UTF-8)";
      binmode STDOUT, ":encoding(UTF-8)";
   }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
')
}

PROMPT="%{$fg[green]%}%$(_fishy_collapsed_wd)%{$reset_color%} "

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
