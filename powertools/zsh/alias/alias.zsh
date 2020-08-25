alias :r='source $ZDOTDIR/.zshrc; '

alias sudo="sudo "

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

pdf() {
    zathura $@ &
    disown
}

png() {
    sxiv $@ &
    disown
}

hist_stats() {
    fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n20
}

make() {
    if [ -e Makefile ] || [ -e makefile ]; then
        bash -c "make -j$(nproc || echo 4) $*"
    else
        for i in *.c; do
            file=${i//\.c/}
            bash -c "make $file"
        done
    fi
}

dock(){
    setxkbmap pt -option caps:esc
    xrandr --output DP-2-2 --auto
    xrandr --output eDP-1 --off
    wallpaper
}

undock(){
    setxkbmap gb -option caps:esc
    xrandr --output eDP-1 --auto
    xrandr --output DP-2-2 --off
    wallpaper
}
