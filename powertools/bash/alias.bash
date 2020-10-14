alias :r='source ~/.bashrc'
alias :q='exit'

alias sudo="sudo "

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias mkcd='mkdir -p "$@" && cd "$@"'

alias ls='ls --color=auto'
alias l='ls -lah'

alias grep='grep --color=auto --exclude-dir=.git'
alias watch='watch --color'


alias c='clear'
alias cl='clear; ls -lah'

alias stahp='poweroff'

alias vim="nvim"
alias viminstall='vim +:PlugClean +:PlugInstall +:PlugUpdate +:PlugUpgrade'
alias cleantex='rm *.{aux,idx,log,nav,out,snm,toc,vrb,bbl,blg}(.N) 2>/dev/null'

alias tr="transmission-remote"
alias tra="transmission-remote -a"
alias trl="transmission-remote -l"

alias py="python"
alias ghc="stack ghc"
alias ghci="stack ghci"
alias grind="valgrind --leak-check=full --show-reachable=no --show-leak-kinds=all"

alias tmux='tmux -2'
alias wget="wget --no-hsts"

za() {
    zathura $@ &
    disown
}

png() {
    sxiv $@ &
    disown
}

alias starwars='telnet towel.blinkenlights.nl'

alias mi='oneko -tora -name Mi & disown'
alias byemi='killall oneko'
