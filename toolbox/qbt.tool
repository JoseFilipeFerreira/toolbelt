#!/bin/python
"""qbittorrent management on remote"""

# to setup for firefox:
# 1. open about:config
# 2. network.protocol-handler.expose.magnet = false
# 3. open magnet link and select ~/.local/bin/tr as default magnet link

import socket
from sys import argv
from subprocess import Popen, PIPE
from typing import List

def notify(header, content):
    """Send notifications with notify-send"""
    with Popen(
        ["notify-send", "-a", "qbt" ,"-i", "apps/qbittorrent", header, content],
            stdout=PIPE, stderr=PIPE) as proc:
        proc.communicate()

def connect():
    from qbittorrentapi import Client
    soc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    soc.connect(("8.8.8.8", 80))
    local_ip = soc.getsockname()[0]
    return Client(host=f'{local_ip}:8090')

def print_torrents():
    print(
        "{:<3} {:<9} {:<5} {:<7} {:<7} {:<6} {:<8} {}".format("ID", "Category", "Done", "Up", "Down", "Ratio", "Status", "Name"))

    for i, torrent in enumerate(connect().torrents_info()):
        # Category
        cat = torrent.category
        cat = cat if cat != "" else "-"
        # Done
        progress = f"{round(torrent.progress * 100)}%"
        # ETA
        # Up
        up = torrent.upspeed
        up = up if up > 0 else "-"
        # Down
        down = torrent.dlspeed
        down = down if down > 0 else "-"

        ratio = round(torrent.ratio, 1)

        status="Unknown"
        if torrent.state_enum.is_checking:
            status="Check"
        elif torrent.state_enum.is_complete:
            status="Done"
        elif torrent.state_enum.is_downloading:
            status="Down"
        elif torrent.state_enum.is_errored:
            status="Error"
        elif torrent.state_enum.is_paused:
            status="Pause"
        elif torrent.state_enum.is_uploading:
            status="Up"
        # Name
        name = torrent.name

        print("{:<3} {:<9} {:<5} {:<7} {:<7} {:<6} {:<8} {}".format(i, cat, progress, up, down, ratio, status, name))


def main():
    """main entry function"""
    if socket.gethostname() == "kiwi":
        if argv[1] in ["--list", "-l"]:
            print_torrents()
        elif argv[1] in ["--add", "-a"]:
            connect().torrents_add(urls=argv[2])
        elif argv[1] in ["-rm", "--remove"]:
            print("Not implemented")
            exit()
        elif argv[1].startswith("magnet:"):
            connect().torrents_add(urls=argv[1])
        else:
            print("USAGE: qbt [--list|--add]")
    else:
        with Popen(["ssh", "kiwi", ".local/bin/qbt"] + argv[1:], stdout=PIPE, stderr=PIPE) as proc:
            stdout, _ = proc.communicate()
            stdout = stdout.decode("utf-8")

            print(stdout)
            if stdout == "Ok.":
                notify("Added Torrent", "on kiwi")
            elif stdout == "Fails.":
                notify("Failed to Add Torrent", "on kiwi")

if __name__ == '__main__':
    main()
# vim: set ft=python:
