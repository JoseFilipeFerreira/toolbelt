alias gst='git status'
alias gb='git branch'

alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout master'

alias gl='git pull'
gcl() {
    git clone git@github.com:$1
}

alias ga='git add'

alias gc='git commit -v'

alias gp='git push'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'

alias grhh='git reset --hard'

alias glog="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glogs="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
alias glogd="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
