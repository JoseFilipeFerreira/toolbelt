alias :r='source ~/.bashrc'
alias :q='exit'

alias sudo='sudo '

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

alias ls='ls --color=auto'
alias l='ls -lah'

alias grep='grep --color=auto --exclude-dir=.git'
alias watch='watch --color'

command -v neofetch &>/dev/null ||
    alias neofetch="curl --silent jff.sh/share/neofetch | bash"

alias c='clear'
alias cl='clear; ls -lah'

alias stahp='poweroff'

if command -v nvim &>/dev/null; then
    alias vim="nvim"
    alias viminstall='nvim +:PlugClean +:PlugInstall +:PlugUpdate +:PlugUpgrade'
fi
alias cleantex='rm *.{aux,idx,log,nav,out,snm,toc,vrb,bbl,blg}(.N) 2>/dev/null'

alias py="python"
alias ghc="stack ghc"
alias ghci="stack ghci"
alias grind="valgrind --leak-check=full --show-reachable=no --show-leak-kinds=all"

alias tmux='tmux -2'

alias starwars='telnet towel.blinkenlights.nl'

alias mi='oneko -tora -name Mi & disown'
alias byemi='killall oneko'

alias raycaster='awk -f <(curl https://raw.githubusercontent.com/TheMozg/awk-raycaster/master/awkaster.awk)'
