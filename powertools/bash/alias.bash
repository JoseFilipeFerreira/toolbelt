alias :r='source ~/.bashrc'
alias :q='exit'

alias sudo='sudo '

alias c='clear'
alias cl='clear; ls -lah'

alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

if hash exa &>/dev/null; then
    alias ls='exa -g'
    alias tree='exa -T'
else
    alias ls='ls --color=auto'
fi
alias l='ls -lah'

alias grep='grep --color=auto --exclude-dir=.git'
alias watch='watch --color'

hash bat &>/dev/null &&
    alias bat='bat --theme=gruvbox-dark -p' &&
    alias cat=bat

hash neofetch &>/dev/null ||
    alias neofetch="curl --silent https://jff.sh/share/neofetch | bash"

alias stahp='poweroff'

alias cleantex='rm *.{aux,idx,log,nav,out,snm,toc,vrb,bbl,blg}(.N) 2>/dev/null'

hash nvim &>/dev/null &&
    alias vim="nvim"

hash python &>/dev/null &&
    alias py="python"

hash stack &>/dev/null &&
    alias ghc="stack ghc" &&
    alias ghci="stack ghci"

hash valgrind &>/dev/null &&
    alias grind="valgrind --leak-check=full --show-reachable=no --show-leak-kinds=all"

hash tmux &>/dev/null &&
    alias tmux='tmux -2'

hash telnet &>/dev/null &&
    alias starwars='telnet towel.blinkenlights.nl'

hash oneko &>/dev/null &&
    alias mi='oneko -tora -name Mi & disown' &&
    alias byemi='killall oneko'

hash awk &>/dev/null &&
    alias raycaster='awk -f <(curl https://raw.githubusercontent.com/TheMozg/awk-raycaster/master/awkaster.awk)'

hash nsxiv &>/dev/null &&
    alias sxiv='nsxiv'

# ~/ clean-up
hash yarn &>/dev/null &&
    alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'
