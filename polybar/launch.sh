#!/bin/bash

killall -q pollybar

while pgrep -u $UID -x pollybar >/dev/null; do sleep 1; done

polybar -c ~/.config/polybar/config/config mightybar
