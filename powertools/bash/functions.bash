mkcd(){
    mkdir -p "$@"
    cd "$@" || return
}

za(){
    zathura "$@" &
    disown
}

png(){
    nsxiv "$@" &
    disown
}

which(){
    local w
    w="$(command -V "$1")"
    case "$w" in
        *'is a function'*)
            echo "${w#*$'\n'}"
            ;;
        *'is aliased to'*)
            w="${w#*\`}"
            echo "${w%\'*}"
            ;;
        *)
            echo "${w##* }"
            ;;
    esac
}

hist_stats(){
    fc -l 1 | \
    awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
    grep -v "./" | \
    column -c3 -s " " -t | \
    sort -nr | \
    nl | \
    head -n20
}

make(){
    if [ -e Makefile ] || [ -e makefile ]; then
        bash -c "make -j$(nproc || echo 4) $*"
    else
        for i in *.c; do
            file=${i//\.c/}
            bash -c "make $file"
        done
    fi
}

tidy(){
    clang-tidy "$1" \
        -checks="*",clang-analyzer"*",-clang-analyzer-cplusplus"*" \
        -- -std=c++20 \
        -Wall \
        -Wextra \
        -Wdouble-promotion \
        -Werror=pedantic \
        -Werror=vla \
        -pedantic-errors \
        -Wfatal-errors \
        -flto \
        -Iinclude
}

explode(){
    [[ "$#" -ne 1 ]] && echo "USAGE: explode DIR" && return
    [[ ! -d "$1" ]] && echo "$1 not a dir" && return
    mv "$1"/* .
    rmdir "$1"
}

srsync(){
    [[ "$#" -lt 3 ]] &&
        echo "USAGE: srsync REMOTE :REMOTE_DIR LOCAL_DIR" &&
        return
    sudo rsync -av -e "ssh $USER@$1 -i $HOME/.ssh/id_rsa" "$2" "$3" --progress
}

nest() {
    # example:
    # nest new-dir *
    [[ "$#" -lt 2 ]] &&
        echo "USAGE: nest NEW_DIR FILE...." &&
        return

    tmp=..
    [ "$PWD" = / ] && tmp=/tmp
    dir="$tmp/$1"
    echo "Nest files in $1 (tmp on $dir)"
    read
    mkdir "$dir" || return
    mv "${@:2}" "$dir" || return
    mv "$dir" . || return
}

ingest(){
    [ "$#" -ne 2 ] && echo "USAGE: ingest DRIVE FOLDERNAME" && return
    mkdir -vp /tmp/ingest
    mkdir -vp "$2"
    sudo mount "$1" /tmp/ingest
    rsync -av --info=progress2 /tmp/ingest/ "$2"
    sudo umount /tmp/ingest
    rmdir -v /tmp/ingest
    find "$2" -type f -exec chmod 0644 {} +
}

gifify(){
    convert -limit memory 64 -delay 50 -loop 0 -dispose previous "$@"
}
