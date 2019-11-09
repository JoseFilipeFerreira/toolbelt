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

# List directory contents
alias ls='ls --color=auto'
alias l='ls -lah'

alias grep='grep --color=auto --exclude-dir=.git'
alias pygrep='grep -r --include="*.py"'


function mkcd() {
  mkdir -p $@
  cd $@
}

function nospace (){
    for file in *; do mv $file $(echo $file | sed -r 's/ - /-/g;s/ _ /_/g;s/,//g;s/\(//g;s/\)//g;s/\!//g;s/ /_/g'); done;
}
