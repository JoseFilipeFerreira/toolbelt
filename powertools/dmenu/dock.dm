LAYOUT=$(echo -e "dock\nundock\nsplit" | dmenu -i -p "Monitor Layout")
[ "$LAYOUT" = "" ] && exit 2 

case "$LAYOUT" in
        dock)
            xrandr --output HDMI2 --auto
            xrandr --output eDP1 --off
            ;;

        undock)
	    xrandr --output HDMI2 --off
	    xrandr --output eDP1 --auto
            ;;
         
esac

changeWall
