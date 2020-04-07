#!/bin/bash
notImage=$DOTFILES/assets/miei.png

p=$(calendar --curr)
if [ $p ] && [ -d $MIEI_NOTES/$p"-UM" ]; then 
    cd -P $MIEI_NOTES/$p"-UM";
    notify-send -i $notImage -u low -a dateTerm "Subject: $p" "@$(calendar --curr-location)"
else
    cd $MIEI;
    notify-send -i $notImage -u low -a dateTerm "Not in class"
fi
$TERMINAL
