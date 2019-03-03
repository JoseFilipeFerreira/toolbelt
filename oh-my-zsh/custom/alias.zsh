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

#better mpv with plugins
function pdf {
    if [ $1 = "" ]; then
        echo "Usage: $0 <file>"
    else
        zathura $1 &
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