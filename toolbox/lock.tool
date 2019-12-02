#!/bin/bash
scrot -o /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x5 /tmp/screenshot.png
i3lock -i /tmp/screenshot.png
rm /tmp/screenshot.png
