LAYOUT=$(echo -e "dock\nundock\nsplit\nsplit(vert)\nmirror" | dmenu -i -p "Monitor Layout")
[ "$LAYOUT" = "" ] && exit 2 
UPDATE=$(echo -e "Yes\nNo" | dmenu -i -p "Update Wallpaper?")
[ "$UPDATE" = "" ] && exit 2

case "$LAYOUT" in
        dock)
            xrandr --output HDMI2 --auto
            xrandr --output eDP1 --off
            ;;

        undock)
	    xrandr --output HDMI2 --off
	    xrandr --output eDP1 --auto
            ;;
         
        split)
            xrandr --output HDMI2 --auto
            ;;
        split\(vert\))
            xrandr --above --output HDMI2 --auto
            ;;
        mirror)
            xrandr --output HDMI2 --auto
esac

if [ "$UPDATE" = "Yes" ]
then
    wallup
else
    wallup --no-update
fi
