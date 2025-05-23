#!/bin/bash
# dmenu/tofi/fzf wrapper (by [Mendess](https://github.com/mendess))

use_tofi() {
    args=()
    [ "$prompt" ] && args+=(--prompt "$prompt ")
    [ "$bg_color" ] && args+=(--background-color "${bg_color}DD")
    [ "$text_color" ] && args+=(--text-color "$text_color")
    [ "$selection_bg_color" ] && args+=(
        --border-color "$selection_bg_color"
        --selection-background "$selection_bg_color"
    )
    [ "$selection_text_color" ] && args+=(--selection-color "$selection_text_color")
    [ "$lines" ] && args+=(--num-results "$lines")
    [ "$require_match" ] && args+=(--require-match "$require_match")
    tofi "${args[@]}"
}

use_dmenu() {
    args=()
    [ "$prompt" ] && args+=(-p "$prompt")
    [ "$bg_color" ] && args+=(-nb "$bg_color")
    [ "$text_color" ] && args+=(-nf "$text_color")
    [ "$selection_bg_color" ] && args+=(-sb "$selection_bg_color")
    [ "$selection_text_color" ] && args+=(-sf "$selection_text_color")
    [ "$case_insensitive" ] && args+=(-i)
    [ "$lines" ] && args+=(-l "$lines")
    [ "$font" ] && args+=(-fn "$font")
    dmenu "${args[@]}"
}

use_fzf() {
    args+=()
    [ "$prompt" ] && args+=(--prompt "$prompt")
    [ "$require_match" = true ] && args+=(--print-query)
    fzf "${args[@]}"
}

mapfile -t wall_colors < <(tr ' ' '\n' < "/tmp/$LOGNAME/wall_colors")

selection_bg_color=${wall_colors[0]}
selection_text_color=${wall_colors[1]}
bg_color="${wall_colors[4]}"
text_color=${wall_colors[5]}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -i)
            case_insensitive=1
            shift
            continue
            ;;
        -fn) font="$2" ;;
        -l) lines=$2 ;;
        --print-query)
            require_match=true
            shift
            continue
            ;;
        --require-match) require_match=$2 ;;
        -p|--prompt) prompt=$2 ;;
        -nb|--background-color) bg_color=$2 ;;
        -nf|--text-color) text_color=$2 ;;
        -sb|--border-color|--selection-background) selection_bg_color=$2 ;;
        -sf|--selection-color) selection_text_color=$2 ;;
        *)
            echo "unrecognized option $1"
            exit 1
    esac
    shift
    shift
done

if [ -t 0 ]; then
    use_fzf
elif [ "$WAYLAND_DISPLAY" ]; then
    if [[ "$0" = *dmenu* ]]; then
        require_match=false
    fi
    use_tofi
else
    use_dmenu
fi

