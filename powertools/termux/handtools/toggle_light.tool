#!/data/data/com.termux/files/usr/bin/bash
# toggle lights
status="$(ssh mightymime@jff.sh 'curl --silent localhost:4200/bulb/toggle')"
termux-toast -g bottom "lights: $status"
