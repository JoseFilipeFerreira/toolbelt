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

while true; do
    clear
    # print grid with escape codes
    for grid in "${grid_vec[@]}"; do
        if [[ "$grid" = "\n" ]]; then
            echo
        else
            eval echo -en "$grid"
        fi
    done
    echo
    echo
    echo -e "$c1$pixel$c2$pixel$c3$pixel$c4$pixel$c5$pixel$c6$pixel$reset_color"
    echo " 1 2 3 4 5 6"

    # reset curr color if screen empty
    [[ "${#grid_vec[@]}" -eq 0 ]] &&
        unset curr_color

    read -n 1

    case "$REPLY" in
        # draw color
        [1-6])
            if ! [[ "$curr_color" == "$REPLY" ]]; then
                curr_color="$REPLY"
                grid_vec+=( "\${c$REPLY}" )
            fi
            grid_vec+=( "$pixel" )
            ;;
        # space
        " ")
            grid_vec+=( "$tmp_space" )
            ;;
        # enter
        "")
            grid_vec+=( "\n" )
            ;;
        # delete
        x|X)
            [[ "${#grid_vec[@]}" -gt 0 ]] &&
                unset "grid_vec[-1]"
            [[ "${#grid_vec[@]}" -gt 0 ]] &&
            [[ "${grid_vec[-1]}" != "$pixel" ]] &&
                unset "grid_vec[-1]"
            ;;
        # clear all
        c|C)
            read -p "Clear all(y/N)?" choice
            case "$choice" in
              y|Y ) grid_vec=();;
            esac
            ;;
        # save and exit
        $'\e')
            read -p "Save and Exit(y/N)?" choice
            case "$choice" in
              y|Y ) break;;
            esac

            ;;
        *)
            echo "invalid key"
    esac


done

#print result to file
echo "ascii_colors=($1 $2 $3 $4 $5 $6)"
touch "$file"
for grid in "${grid_vec[@]}"; do
    echo -en "$grid" | sed "s/$tmp_space/  /g" >> "$file"
done
