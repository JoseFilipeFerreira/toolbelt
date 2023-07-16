#!/usr/bin/env python3
""" help me focus (by [Mendes](https://github.com/mendess/))"""

import time
import re
import subprocess

window_ban_list = [
    re.compile('discord', re.I),
    re.compile('scryfall', re.I),
]

unfocused = 0

def get_current_window_title():
    window_id = subprocess.check_output([
        "bash",
        "-c",
        "xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/ { print $NF }'"
    ])
    return subprocess.check_output([
        "bash",
        "-c",
        """xprop -id "{}" | awk '/_NET_WM_NAME/ {{ $1=$2=""; print }}' | cut -d '"' -f2""".format(window_id.decode('utf8').strip())
    ]).decode('utf8').strip()

try:
    for _ in range(0, 2):
        now = time.time()
        in3hours = now + (60 * 60 * 3)
        subprocess.call(["notify-send", "-u", "critical", "work time"])

        while now < in3hours:
            time.sleep(1)
            window_title = get_current_window_title()
            print(window_title)
            if any(b.search(window_title) for b in window_ban_list):
                subprocess.call(["notify-send", "-u", "critical", f"work {unfocused}"])
                unfocused += 1

            now = time.time()


        subprocess.call(["notify-send", "-u", "critical", "you can rest now if you want"])
        time.sleep(60 * 60 * 1)
finally:
    subprocess.call(["notify-send", "-u", "low", "focus time finished"])

# vim: set ft=python:
