#!/bin/bash

# check if in a termux install
! hash termux-job-scheduler &> /dev/null && echo "Not in termux env" && exit

script_folder="$DOTFILES"/powertools/termux/handtools
dest_folder=~/.termux/tasker

xresources_file="$DOTFILES"/powertools/X11/Xresources
color_properties=~/.termux/colors.properties

termux_task_set(){
    echo -e "\033[35mSetting task:\033[33m $1 (every: $2 ms)\033[0m"
    termux-job-scheduler \
        --script "$script_folder/$1.tool" \
        --period-ms "$2" \
        --persisted true
}

case "$1" in
    check)
        # check colors.properties
        [[ -f "$color_properties" ]] && [[ "$color_properties" -nt "$xresources_file" ]] || exit 0

        # check scripts
        [[ -d "$dest_folder" ]] || exit 0

        for tool in "$dest_folder"/*; do
            [[ -f "$script_folder/$(basename "$tool").tool" ]] || exit 0
        done

        for tool in "$script_folder"/*.tool; do
            [[ "$tool" -nt "$dest_folder/$(basename "$tool" .tool)" ]] && exit 0
        done

        exit 1
        ;;

    *)
        # generate colors.properties
        grep -E "\*\.(color[0-9]+|background|foreground)" "$xresources_file" |
            sed 's/*.//' >| "$color_properties"
            mkdir -p "$dest_folder"

        # copy scripts
        for tool in "$dest_folder"/*; do
            tool_name="$(basename "$tool")"
            if [[ ! -f "$script_folder/${tool_name}.tool" ]]; then
                echo -e "\033[31m$tool_name\033[0m"
                rm "$tool"
            fi
        done

        for tool in "$script_folder"/*.tool; do
            tool_name=$(basename "$tool" .tool)
            tool_dest="$dest_folder/$tool_name"
            if [[ "$tool" -nt "$tool_dest" ]]; then
                echo -e "\033[32m$tool_name\033[0m"
                cp "$tool" "$tool_dest"
            fi
        done
        ;;
esac

# termux-job-scheduler --cancel-all
# termux_task_set change_lock 900000
