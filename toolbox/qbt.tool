#!/bin/python
# add torrent to qbittorrent on remote

# to setup for firefox:
# 1. open about:config
# 2. network.protocol-handler.expose.magnet = false
# 3. open magnet link and select ~/.local/bin/tr as default magnet link

import sys
from subprocess import Popen, PIPE
from qbittorrentapi import Client
import socket

def notify(header, content):
    Popen(
        ["notify-send", "-a", "qbt" ,"-i", "apps/qbittorrent", header, content],
        stdout=PIPE, stderr=PIPE).communicate()

magnet = sys.argv[1]

if socket.gethostname() == "kiwi":
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    ip = s.getsockname()[0]
    client = Client(host=f'{ip}:8090')

    print(client.torrents_add(urls=magnet))

else:
    stdout, stderr = Popen(["ssh", "kiwi", "qbt", magnet], stdout=PIPE, stderr=PIPE).communicate()
    if stdout == "Ok.":
        notify("Added Torrent", "on kiwi")
    else:
        notify("Failed to Add Torrent", "on kiwi")

# vim: set ft=python:
