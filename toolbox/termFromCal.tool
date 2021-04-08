#!/bin/bash
# contextual terminal based on time (integrates with [calendar](toolbox/calendar.tool))

notImage="$DOTFILES/assets/miei.png"

p=$(calendar --curr)
if [[ "$p" ]] && [[ -d "$HOME/docs/notes/$p" ]]; then
    cd -P "$HOME/docs/notes/$p" || exit 1
    notify-send \
        -i "$notImage" \
        -u low \
        -a dateTerm \
        "Subject: $p" \
        "@$(calendar --curr-location)"
else
    cd "$HOME/repos" || exit 1
    notify-send \
        -i "$notImage" \
        -u low \
        -a dateTerm \
        "Not in class"
fi
$TERMINAL
