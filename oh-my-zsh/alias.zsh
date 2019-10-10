alias :r='source ~/.zshrc; '
alias  c='clear'
alias stahp='poweroff'
alias vim="nvim"
alias cast="castnow --address 192.168.0.188"
alias castvid="castnow --address 192.168.0.129"

#better mpv with plugins
function mvp {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <file>"
    else
        mpv --script ~/.config/mpv/scripts/mpris.so $@ &
        disown
    fi
}

function pdf {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <file>"
    else
        zathura $@ &
        disown
    fi
}

function png {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <file>"
    else
        sxiv $@ &
        disown
    fi
}

function make {
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

function ex {
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

function aura() {
        pushd /tmp >> /dev/null
        git clone https://aur.archlinux.org/$1
        cd $1
        makepkg -si
        popd >> /dev/null
}

function dock {
    xrandr --output HDMI2 --auto
    xrandr --output eDP1 --off
    wallup
}

function undock {
    xrandr --output HDMI2 --off
    xrandr --output eDP1 --auto
}

#speedtest the internet connection
alias speedtest='speedtest-cli'
alias speed='speedtest-cli'

#make a directory and cd into it
function mkcd (){
    case $# in
    1)
        mkdir -p $1
        cd $1
        ;;
    *)
        echo "USAGE : mkcd rep"
        ;;
    esac
}

function isrunning (){
    ps -ef | grep -i $1 | grep -v grep
}

function nospace (){
    for file in *; do mv $file $(echo $file | sed -r 's/ - /-/g;s/ _ /_/g;s/,//g;s/\(//g;s/\)//g;s/\!//g;s/ /_/g'); done;
}

alias grind="valgrind --leak-check=full --show-reachable=no --show-leak-kinds=all"

function matrix (){
    echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

function wallup(){
    sh /home/mightymime/Repos/Nautilus-wallpaper/wallpaper.sh MiEI
}

