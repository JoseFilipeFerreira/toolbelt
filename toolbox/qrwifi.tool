#!/bin/bash
# generate qrcode for the current wifi connection

ssid="$(nmcli -g NAME connection show | grep -v bridge | head -n 1)"

if [[ "$(echo "$ssid" | cut -d: -f3)" ]]; then
    ssid="$(echo "$ssid" | cut -d: -f1)"
else
    exit
fi

pass="$(nmcli -s connection show "$ssid" | grep psk: | grep -o '[^ ]*$')"

qrencode -t ANSI256UTF8 "WIFI:S:$ssid;T:WPA;P:$pass"
