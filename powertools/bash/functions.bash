mkcd(){
    mkdir -p "$@"
    cd "$@" || return
}

za() {
    zathura "$@" &
    disown
}

png() {
    sxiv "$@" &
    disown
}

hist_stats() {
    fc -l 1 | \
    awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
    grep -v "./" | \
    column -c3 -s " " -t | \
    sort -nr | \
    nl | \
    head -n20
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

tidy() {
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
    mv "$1"/* .
    rmdir "$1"
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

gifify() {
    convert -limit memory 64 -delay 50 -loop 0 -dispose previous "$@"
}
