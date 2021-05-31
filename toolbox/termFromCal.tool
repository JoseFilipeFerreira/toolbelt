#!/bin/bash
# contextual terminal based on time (integrates with [calendar](toolbox/calendar.tool))

img="$DOTFILES/assets/miei.png"

p=$(calendar --current)
if [[ "$p" ]] && [[ -d "$HOME/docs/notes/$p" ]]; then
    cd -P "$HOME/docs/notes/$p" || exit 1
    notify-send \
        -i "$img" \
        -u low \
        -a dateTerm \
        "Subject: $p" \
        "@$(calendar --current-location)"
else
    cd "$HOME/repos" || exit 1
    notify-send \
        -i "$img" \
        -u low \
        -a dateTerm \
        "Not in class"
fi
$TERMINAL
