#!/bin/python3
"""qbittorrent management on remote"""

# to setup for firefox:
# 1. open about:config
# 2. network.protocol-handler.expose.magnet = false
# 3. open magnet link and select ~/.local/bin/tr as default magnet link

import socket
import sys
from sys import argv
from subprocess import Popen, PIPE

def notify(header, content):
    """Send notifications with notify-send"""
    try:
        with Popen(
            ["notify-send", "-a", "qbt" ,"-i", "qbittorrent", header, content],
                stdout=PIPE, stderr=PIPE) as proc:
            proc.communicate()
    except OSError as _:
        print(">", header)
        print(content)

def connect():
    """create socket that connects to qbittorrent"""
    # pylint: disable=import-outside-toplevel
    from qbittorrent import Client

    soc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    soc.connect(("8.8.8.8", 80))
    local_ip = soc.getsockname()[0]

    return Client(f'http://{local_ip}:8090/')

def print_torrents():
    """print current torrents"""
    print(
        f"{'ID':3} {'Category':9} {'Done':5} {'Up':7} {'Down':7} {'Ratio':6} {'Status':15} Name")

    for i, torrent in enumerate(connect().torrents()):
        # Category
        cat = torrent["category"]
        cat = cat if cat != "" else "-"
        # Done
        progress = f"{round(torrent['progress'] * 100)}%"
        # ETA
        # Up
        upload = torrent["upspeed"]
        upload = upload if upload > 0 else "-"
        # Down
        down = torrent["dlspeed"]
        down = down if down > 0 else "-"

        ratio = round(torrent["ratio"], 1)

        status=torrent["state"]

        # Name
        name = torrent["name"]

        print(f"{i:3} {cat:9} {progress:5} {upload:7} {down:7} {ratio:6} {status:15} {name}")

def add_torrents(magnet: str):
    """Add torrents to dowload queue"""
    print(connect().download_from_link(magnet))

def main():
    """main entry function"""


    if socket.gethostname() == "kiwi":
        if argv[1] in ["--list", "-l"]:
            print_torrents()
        elif argv[1] in ["--add", "-a"]:
            add_torrents(argv[2])
        elif argv[1] in ["-rm", "--remove"]:
            print("Not implemented")
            sys.exit()
        elif argv[1].startswith("magnet:"):
            add_torrents(argv[1])
        else:
            print("USAGE: qbt [--list|--add]")
    else:
        with Popen(["ssh", "kiwi", ".local/bin/qbt"] + argv[1:], stdout=PIPE, stderr=PIPE) as proc:
            stdout, _ = proc.communicate()
            stdout = stdout.decode("utf-8")

            print(stdout, end="")
            if stdout.startswith("Ok."):
                notify("Added Torrent", "on kiwi")
            elif stdout.startswith("Fails."):
                notify("Failed to Add Torrent", "on kiwi")

if __name__ == '__main__':
    main()
# vim: set ft=python:
