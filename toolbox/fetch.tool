#!/bin/bash
# neofetch wrapper to show logo based on hostname

image="$(hostname | sed 's/\./-/g')"

args=()
while (( $# )); do
    case "$1" in
        --*)
            args+=("$1")
            shift
            ;;
        *)
            image="$1"
            shift
            ;;
    esac
done

color_file=~/.config/neofetch/colors/"$image".colors
ascii_file=~/.config/neofetch/ascii/"$image".ascii

if [[ -f "$color_file" ]] && [[ -f "$ascii_file" ]]; then
    # shellcheck disable=SC1090
    source "$color_file"

    # shellcheck disable=SC2154
    neofetch \
        --colors "${colors[@]}" \
        --ascii_colors "${ascii_colors[@]}" \
        --source "$ascii_file" \
        "${args[@]}"
else
    neofetch
fi
