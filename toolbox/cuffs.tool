#!/bin/bash

file=$(date +'%d%h%Y-%H:%m:%S.png')

while (( "$#" )); do
    case $1 in
      --clipboard|-c)
        clip="true"
        shift
        ;;
    
      --select|-s)
        selection=$(hacksaw -f "-i %i -g %g")
        shift
        ;;
      *)
        shift
        ;;
    esac
done

if [[ "$clip" ]]; then
    shotgun $selection - | xclip -t 'image/png' -selection clipboard
else
    shotgun "$file" $selection
fi
