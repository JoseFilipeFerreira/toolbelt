#!/bin/bash
# change tty colors to the alacritty colorscheme
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P00f0e0e"
    echo -en "\e]P1f22c40"
    echo -en "\e]P25ab738"
    echo -en "\e]P3d5911a"
    echo -en "\e]P4407ee7"
    echo -en "\e]P56666ea"
    echo -en "\e]P600ad9c"
    echo -en "\e]P7a8a19f"
    echo -en "\e]P8766e6b"
    echo -en "\e]P9f22c40"
    echo -en "\e]PA5ab738"
    echo -en "\e]PBd5911a"
    echo -en "\e]PC407ee7"
    echo -en "\e]PD6666ea"
    echo -en "\e]PE00ad9c"
    echo -en "\e]PFf1efee"
    clear
fi
