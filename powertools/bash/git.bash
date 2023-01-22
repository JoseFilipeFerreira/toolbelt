gcl(){
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

gb(){
    if [[ "$1" ]]; then
        git branch "$@"
    else
        git --no-pager branch -vv |
            sed -E 's/ \[[^]]*origin[^]]*\]//' |
            cut -b-"$(tput cols)" |
            GREP_COLORS="mt=1;32" grep --color=always -E '^\* [^/ ]+|' |
            GREP_COLORS="mt=32"   grep --color=always -E '^\* [^ ]+|' |
            GREP_COLORS="mt=33"   grep --color=always -E ' [a-f0-9]{8,10} |' |
            GREP_COLORS="mt=34"   grep --color=always -E '^  [^/]+|'
    fi
}


alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout master || git checkout main'
alias gcd='git checkout develop || git checkout dev'

alias gcw='git switch'
alias gcw-='git switch-'

alias ga='git add'
alias gc='git commit -v'
alias gcwip='git commit -v -m "WIP"'

alias gl='git pull'
gp() {
    if [ $(git log --format=format:%ae | sort -u | wc -l) -gt 1 ]; then
        b=$(git branch)
        case "$b" in
            main|master|dev|develop)
                read -p "You are in '$b', are you sure you want to push? [n/Y] "
                [[ "$REPLY" =~ Y|y ]] || return 0
        esac
    fi
    git push "$@"
}
alias gpsup='git push --set-upstream origin $(git branch --show-current)'

alias grhh='git reset --hard'

__guri() {
    echo "https://github.com/$(git remote get-url --push origin | sed -r 's|.*[:/](.*)/(.*)(.git)?|\1/\2|g')"
}
alias gfi='xdg-open "$(__guri)"'
alias gpr='xdg-open "$(__guri)/pull/new/$(git symbolic-ref --short HEAD)"'
alias gpsup='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

if hash gh &>/dev/null; then
    alias gpsupr='gpsup ; gh pr create -a @me'
else
    alias gpsupr='gpsup && gpr'
fi

alias glog="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glogs="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
alias glogd="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"


wait-for-ci(){
    gh run watch
    notify-send "${1:-CI DONE} ${*:2}" -u critical
}
