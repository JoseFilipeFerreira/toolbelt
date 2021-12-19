gcl() {
    case "$1" in
        git@*|http://*|https://*)
            git clone "$1" "${@:2}"
            ;;
        */*)
            git clone git@github.com:"$1" "${@:2}"
            ;;
        *)
            git clone git@github.com:"$(git config --global user.name)"/"$1" "${@:2}"
            ;;
    esac
}

g(){
    if [ $# -eq 0 ]; then
        git status --short --branch
    else
        git "$@"
    fi
}
alias gd='git diff'

alias gb='git --no-pager branch -vv'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout master || git checkout main'
alias gcd='git checkout develop || git checkout dev'

alias ga='git add'
alias gc='git commit -v'
alias gcwip='git commit -v -m "WIP"'

alias gl='git pull'
alias gp='git push'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'

alias grhh='git reset --hard'

alias gfi='xdg-open https://github.com/$(git remote get-url --push origin | sed -r "s/.*?:(.*)(\.git)?/\1/g")'
alias gpr='xdg-open https://github.com/$(git remote get-url --push origin | sed -r "s/.*?:(.*)(\.git)?/\1/g")/pull/new/$(git symbolic-ref --short HEAD)'
alias gpsupr='gpsup && gpr'

alias glog="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glogs="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
alias glogd="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
