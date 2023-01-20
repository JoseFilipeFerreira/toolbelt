#!/bin/bash

script_folder="$DOTFILES"/powertools/termux/handtools
dest_folder=~/.termux/tasker

! hash termux-job-scheduler &> /dev/null &&
    echo "Not in termux env" && exit

termux_task_set(){
    echo -e "\033[35mSetting task:\033[33m $1 (every: $2 ms)\033[0m"
    termux-job-scheduler \
        --script "$script_folder/$1.tool" \
        --period-ms "$2" \
        --persisted true
}

if [[ ! -d "$dest_folder" ]]; then
    [[ "$1" == "check" ]] && exit 0
    mkdir -p "$dest_folder"
fi

for tool in "$dest_folder"/*; do
    if [[ ! -f "$script_folder/${tool}.tool" ]]; then
        case "$1" in
            check)
                exit 0
                ;;
            *)
                echo -e "\033[31m$(basename "$tool")\033[0m"
                rm "$tool"
                ;;
        esac
    fi
done

for tool in "$script_folder"/*.tool; do
    tool_name=$(basename "$tool" .tool)
    tool_dest="$dest_folder/$tool_name"
    if [[ "$tool" -nt "$tool_dest" ]]; then
        case "$1" in
            check)
                exit 0
                ;;
            *)
                echo -e "\033[32m$tool_name\033[0m"
                cp "$tool" "$tool_dest"
                ;;
        esac
    fi
done

# termux-job-scheduler --cancel-all
# termux_task_set change_lock 900000

exit 1
