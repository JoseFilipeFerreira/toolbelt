mkcd(){
    mkdir -p "$@" && cd "$@"
}

za() {
    zathura $@ &
    disown
}

png() {
    sxiv $@ &
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

explode(){
    mv "$1"/* .
    rmdir "$1"
}

gifify() {
    convert -limit memory 64 -delay 50 -loop 0 -dispose previous "$@"
}
