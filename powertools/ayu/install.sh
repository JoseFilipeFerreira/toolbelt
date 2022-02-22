#!/bin/bash
case "$1" in
    check)
        [[ -d "$HOME"/.local/share/themes/ayu ]]
        ;;
    *)
        wget -P /tmp "https://github.com/Mrcuve0/Aritim-Dark/archive/master.zip"
        unzip -q /tmp/master.zip -d /tmp
        mkdir -p "$HOME"/.local/share/themes
        mv /tmp/Aritim-Dark-master/GTK "$HOME"/.local/share/themes/ayu
        rm -r /tmp/{Aritim-Dark-master,master.zip}
        ;;
esac
