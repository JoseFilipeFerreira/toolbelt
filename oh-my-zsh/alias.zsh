alias :r='source ~/.zshrc; '
alias  c='clear'
alias stahp='poweroff'

#better mpv with plugins
function mvp {
    if [ $1 = "" ]; then
        echo "Usage: $0 <file>"
    else
        mpv --script ~/.config/mpv/scripts/mpris.so $1 &
        disown
    fi
}

function pdf {
    if [ $1 = "" ]; then
        echo "Usage: $0 <file>"
    else
        zathura $1 &
        disown
    fi
}

function png {
    if [ $1 = "" ]; then
        echo "Usage: $0 <file>"
    else
        sxiv $1 &
        disown
    fi
}

#speedtest the internet connection
alias speedtest='speedtest-cli'
alias speed='speedtest'

#make a directory and cd into it
mkcd()
{
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

function isrunning {
    ps -ef | grep -i $1 | grep -v grep
}

#dowload from youtube
alias dy="youtube-dl --embed-thumbnail -o '~/Videos/Youtube/%(title)s.%(ext)s'"
alias dys="youtube-dl -x --audio-format mp3 --embed-thumbnail -o '~/Music/Youtube/%(title)s.%(ext)s'"

alias grind="valgrind --leak-check=full --show-reachable=no --show-leak-kinds=all"

function matrix {
    echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}