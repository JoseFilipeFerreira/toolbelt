alias :r='source ~/.zshrc; '
alias  c='clear'
alias stahp='poweroff'
alias vim="nvim"
alias cast="castnow --address 192.168.0.188"
alias castvid="castnow --address 192.168.0.129"

pdf() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <file>"
    else
        zathura $@ &
        disown
    fi
}

png() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <file>"
    else
        sxiv $@ &
        disown
    fi
}

make() {
    if [ -e Makefile ] || [ -e makefile ]
    then
        bash -c "make $*"
    else
        for i in *.c;
        do
            file=${i//\.c/}
            bash -c "make $file"
        done
    fi
}

ex() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 -v "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.xz)        xz -d "$1"     ;;
      *)           echo "$1 cannot be extracted via ex()" ;;
    esac
  else
    echo "$1 is not a valid file"
  fi
}

dock() {
    xrandr --output HDMI2 --auto
    xrandr --output eDP1 --off
    wallup
}

undock() {
    xrandr --output HDMI2 --off
    xrandr --output eDP1 --auto
    wallup
}

#speedtest the internet connection
alias speedtest='speedtest-cli'
alias speed='speedtest-cli'

isrunning() {
    ps -ef | grep -i $1 | grep -v grep
}

alias grind="valgrind --leak-check=full --show-reachable=no --show-leak-kinds=all"

