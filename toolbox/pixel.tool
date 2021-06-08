#!/bin/bash
# TUI to draw pixelart for [neofetch](powertools/neofetch)
set -e

pixel="██"
tmp_space="__"


if [ "$#" -ne 6 ] && [ "$#" -ne 7 ]; then
    echo "USAGE: pixel color1 color2 color3 color4 color5 color6 FILE"
    exit
fi

c1="\e[$((30 + $1))m"
c2="\e[$((30 + $2))m"
c3="\e[$((30 + $3))m"
c4="\e[$((30 + $4))m"
c5="\e[$((30 + $5))m"
c6="\e[$((30 + $6))m"

file="output.ascii"
[[ "$7" ]] && file="$7"

reset_color="\e[0m"

grid_vec=()
clear
select option in draw space enter delete change_color clear; do
    clear
    case "$option" in
        draw)
            grid_vec+=( "$pixel" )
            ;;
        space)
            grid_vec+=( "$tmp_space" )
            ;;
        enter)
            grid_vec+=( "\n" )
            ;;
        delete)
            unset "grid_vec[-1]"
            ;;
        change_color)
            while :; do
                clear
                echo -e "1) $c1$pixel$reset_color"
                echo -e "2) $c2$pixel$reset_color"
                echo -e "3) $c3$pixel$reset_color"
                echo -e "4) $c4$pixel$reset_color"
                echo -e "5) $c5$pixel$reset_color"
                echo -e "6) $c6$pixel$reset_color"
                read -r -p "#?" val
                [[ "$val" -ge "1" ]] && [[ "$val" -le "6" ]] && grid_vec+=( "\${c$val}" ) && break
            done
            clear
            ;;
        clear)
            grid_vec=()
            ;;
        *)
            echo "invalid option"
            ;;
    esac
    # print grid with escape codes
    for grid in "${grid_vec[@]}"; do
        if [[ "$grid" = "\n" ]]; then
            echo
        else
            eval echo -en "$grid"
        fi
    done
    echo -e "\e[0m"
done

#print result to file
echo "ascii_colors=($1 $2 $3 $4 $5 $6)"
touch "$file"
for grid in "${grid_vec[@]}"; do
    echo -en "$grid" | sed "s/$tmp_space/  /g" >> "$file"
done
