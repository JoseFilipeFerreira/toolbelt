#!/bin/python
"""add torrent to qbittorrent on remote"""

# to setup for firefox:
# 1. open about:config
# 2. network.protocol-handler.expose.magnet = false
# 3. open magnet link and select ~/.local/bin/tr as default magnet link

import socket
import sys
from subprocess import Popen, PIPE
from qbittorrentapi import Client

def notify(header, content):
    """Send notifications with notify-send"""
    with Popen(
        ["notify-send", "-a", "qbt" ,"-i", "apps/qbittorrent", header, content],
            stdout=PIPE, stderr=PIPE) as proc:
        proc.communicate()

magnet = sys.argv[1]


def main():
    if socket.gethostname() == "kiwi":
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        client = Client(host=f'{ip}:8090')

        print(client.torrents_add(urls=magnet))

    else:
        with Popen(["ssh", "kiwi", "qbt", magnet], stdout=PIPE, stderr=PIPE) as proc:
            stdout, stderr = proc.communicate()

            if stdout == "Ok.":
                notify("Added Torrent", "on kiwi")
            else:
                notify("Failed to Add Torrent", "on kiwi")

if __name__ == '__main__':
    main()
# vim: set ft=python:
