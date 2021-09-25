#!/bin/bash
# open terminal in the current user, machine and directory

wt="$(xdotool getwindowfocus getwindowname)"

[[ "$wt" =~ ^.+@.+:.+$ ]] || {
    notify-send -u low -a termFromHere "Couldn't find cwd"
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
