#!/bin/bash
options=()

while (( "$#" )); do
    case $1 in
      --clipboard|-c)
        options+=(-e 'xclip -sel clip -t image/png $f && rm $f')
        shift
        ;;
    
      --select|-s)
        options+=(-f -s)
        shift
        ;;
    
      --delay|-d)
        options=(-d "$2")
        shift 2
        ;;
    
      *)
        shift
        ;;
    esac
done

scrot '%d%h%Y-%H:%m:%S_$wx$h.png' "${options[@]}"
