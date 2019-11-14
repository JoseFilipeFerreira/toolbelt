cat $DOTFILES/toolbox/.timetable | grep ^$(date +%u) | awk -v h=$(date +%H) -F: '{ if (h >= $2 && h < $3) {system("cd $MIEI_NOTES/"$4"-UM; termite")}}' 
