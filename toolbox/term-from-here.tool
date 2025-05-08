#!/bin/bash
# open terminal in the current user, machine and directory

get_window_name(){
    # Hyprland
    if [[ -n "$WAYLAND_DISPLAY" ]] && command -v hyprctl &>/dev/null; then
        hyprctl activewindow -j | jq -r '.title' 2>/dev/null
    # X11
    elif [[ -n "$DISPLAY" ]] && command -v xdotool &>/dev/null; then
        xdotool getwindowfocus getwindowname 2>/dev/null
    else
        return 1
    fi
}


wt="$(get_window_name)"

[[ "$wt" =~ ^.+@.+:.+$ ]] || {
    notify-send -i terminal -u low -a "$(basename "$0")" "Couldn't find cwd"
    "$TERMINAL" "$@" &
}

user="$(echo "$wt" | cut -d":" -f1 | cut -d"@" -f1)"
host="$(echo "$wt" | cut -d":" -f1 | cut -d"@" -f2)"
wdir="$(echo "$wt" | cut -d":" -f2 | sed -E "s|~|/home/$user|g" )"

echo "$wdir"
if [[ "$host" = "$(hostname)" ]]; then
    cd "$wdir" || exit 1
    "$TERMINAL" "$@" &
else
    "$TERMINAL" -e ssh -t "$user@$host" "cd $wdir && bash --login" &
fi

disown
exit
