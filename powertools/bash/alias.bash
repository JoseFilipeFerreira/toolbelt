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
alias tree='tree -AC'

command -V bat &> /dev/null &&
    alias bat='bat --theme=gruvbox-dark -p' &&
    alias cat=bat

command -v neofetch &>/dev/null ||
    alias neofetch="curl --silent jff.sh/share/neofetch | bash"

alias c='clear'
alias cl='clear; ls -lah'

alias stahp='poweroff'

alias cleantex='rm *.{aux,idx,log,nav,out,snm,toc,vrb,bbl,blg}(.N) 2>/dev/null'

command -v nvim &>/dev/null &&
    alias vim="nvim" &&
    alias viminstall='nvim +:PlugClean +:PlugInstall +:PlugUpdate +:PlugUpgrade'

command -V python &> /dev/null &&
    alias py="python"

command -V stack &>/dev/null &&
    alias ghc="stack ghc" &&
    alias ghci="stack ghci"

command -V valgrind &>/dev/null &&
    alias grind="valgrind --leak-check=full --show-reachable=no --show-leak-kinds=all"

command -V tmux &> /dev/null &&
    alias tmux='tmux -2'

command -V telnet &> /dev/null &&
    alias starwars='telnet towel.blinkenlights.nl'

command -V oneko &> /dev/null &&
    alias mi='oneko -tora -name Mi & disown' &&
    alias byemi='killall oneko'

command -V awk &> /dev/null &&
    alias raycaster='awk -f <(curl https://raw.githubusercontent.com/TheMozg/awk-raycaster/master/awkaster.awk)'

# ~/ clean-up
command -V yarn &> /dev/null &&
    alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'
