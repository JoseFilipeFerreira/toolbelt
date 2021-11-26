#!/bin/bash
# generate qrcode for the current wifi connection

ssid="$(nmcli -g NAME,TYPE,DEVICE connection show | grep "wireless" | head -n 1)"

if [[ "$(echo "$ssid" | cut -d: -f3)" ]]; then
    ssid="$(echo "$ssid" | cut -d: -f1)"
else
    exit
fi

pass="$(nmcli -s connection show "$ssid" | grep psk: | grep -o '[^ ]*$')"

#shellcheck disable=SC2001
ssid="$(echo "$ssid" | sed 's/ [0-9]\+$//')"

echo "SSID: $ssid"
qrencode -t ANSI256UTF8 "WIFI:S:$ssid;T:WPA;P:$pass"
