#!/bin/python
# TUI to download from [nyaa](https://nyaa.si) based on watching list from [MAL](https://myanimelist.net)
import os
import re
import sys
from dataclasses import dataclass
from enum import Enum
from json import loads
from pathlib import Path
from subprocess import PIPE, STDOUT, Popen
from typing import List, Optional
from urllib.parse import urlencode

import requests
from bs4 import BeautifulSoup

ANIME_LOCATION = "/home/mightymime/media/anime"
if not os.path.isdir(ANIME_LOCATION):
    print("Invalid anime location:", ANIME_LOCATION)
    sys.exit()

THUMB_LOCATION = "/home/mightymime/repos/iron_cake/thumb/anime"
if not os.path.isdir(THUMB_LOCATION):
    print("Invalid thumb location:", THUMB_LOCATION)
    sys.exit()

def print_info(s: str):
    print(f"[info] {s}")

def print_error(s: str):
    print(f"[error] {s}")

class ListType(Enum):
    WATCHING = 1
    COMPLETED = 2
    ONHOLD = 3
    DROPPED = 4
    PLAN2WATCH = 6

class MediaType(Enum):
    ANIME = "animelist"
    MANGA = "mangalist"

@dataclass
class NyaaResult():
    title: str
    id: str
    magnet: str
    size: str
    date: str
    seeders: int
    leechers: int
    completed: int

    def is_valid_result(self, episode: Optional[int], searched_title:str) -> bool:
        if not episode:
            return True

        if searched_title.lower() not in self.title.lower():
            return False

        matches = re.findall(r'\[[0-9a-zA-Z]+\]', self.title)
        clean_title = self.title
        for b in matches:
            clean_title = clean_title.replace(b, "")

        if re.search(f' {episode} ', self.title) or re.search(f'S[0-9]*E{episode}', self.title):
            return True

    def queue_magnet_link(self):
        output, error = Popen(
            ["transmission-remote", "--add", self.magnet],
            stdout=PIPE,
            encoding='utf-8'
        ).communicate()

        return None if error else output

@dataclass
class MalResult():
    num_watched_episodes: int
    title: str
    num_episodes: int
    id: int
    url: str
    image_path: str

    def __init__(self, d):
        self.num_watched_episodes = d['num_watched_episodes']
        self.title = d['title']
        self.num_episodes = d['num_episodes']
        self.id = d['id']
        self.url = d['url']
        self.image_path = d['image_path']
        self.clean_title = self.title.replace("!", "").replace(" ", "_").replace(".", "")
        self.anime_path = ANIME_LOCATION + "/" + self.clean_title

    def mkdir(self):
        Path(self.anime_path).mkdir(parents=True, exist_ok=True)

    def download_thumb(self):
        path = THUMB_LOCATION + "/" + self.clean_title + ".jpg"

        if os.path.exists(path):
            return

        print_info("downloading image: " + path)
        url = "http://myanimelist.net" + self.url
        soup = BeautifulSoup(requests.get(url).content, "html.parser")
        image_url = soup.find("img", {"class", "ac"})["data-src"]

        os.makedirs(os.path.dirname(path), exist_ok=True)

        response = requests.get(image_url)
        if response.status_code == 200:
            with open(path, 'wb') as f:
                f.write(response.content)
        else:
            print_error("could not download image")

def get_mal(
    user: str,
    media: MediaType = MediaType.ANIME,
    state: ListType = ListType.WATCHING) -> List[MalResult]:

    url = f'https://myanimelist.net/{media.value}/{user}?status={state.value}'
    soup = BeautifulSoup(requests.get(url).content, "html.parser")
    table = soup.find('table', {"class", "list-table"})

    res = []
    for line in loads(table['data-items']):
        res.append(
            MalResult(
                {k.replace(media.name.lower() + "_", ""): v for k, v in line.items()}))

    return res

def get_nyaa(title: str) -> List[NyaaResult]:
    getVars = {'f': 0, 'c': '1_2', 'q': f"{title}"}
    url = f"https://nyaa.si/?{urlencode(getVars)}"
    soup = BeautifulSoup(requests.get(url).content, "html.parser")
    table = soup.find('table')
    if not table:
        return None
    content = table.find('tbody')

    res = []
    for line in content.find_all('tr'):
        line_vec = line.find_all('td')
        res.append(
            NyaaResult(
                title = line_vec[1].find_all('a')[-1]['title'],
                id = line_vec[1].find_all('a')[-1]['href'],
                magnet = line_vec[2].find_all('a')[1]['href'],
                size = line_vec[3].contents[0],
                date = line_vec[4].contents[0],
                seeders = line_vec[5].contents[0],
                leechers = line_vec[6].contents[0],
                completed = line_vec[7].contents[0]))
    return res

def get_last_anime(anime_path: str) -> int:
    dl_animes = os.listdir(anime_path)
    dl_animes.sort(reverse=True)

    if len(dl_animes) == 0:
        return None

    try:
        return int(re.search(r'E([0-9]+?)\.', dl_animes[0]).group(1))
    except:
        print_error(f"invalid filename: {dl_animes[0]}")
        return None

def prompt_torrent(name: str, content: List[NyaaResult]) -> Optional[NyaaResult]:
    output, error = Popen(
        ["fzf", "--cycle", f"--header='search: {name}'"],
        stdout=PIPE,
        stdin=PIPE,
        encoding="utf-8"
    ).communicate("\n".join([x.title for x in content])+"\n")

    if error or not output:
        return None

    anime = list(filter(lambda x: x.title == output.strip(), content))

    return None if not anime else anime[0]

def main():
    print_info("fetching users animes")
    animes = get_mal("nifernandes")

    print()
    for anime in animes:
        anime.download_thumb()
        anime.mkdir()

    for anime in animes:
        search_nyaa = anime.title
        last_anime = get_last_anime(anime.anime_path)
        next_anime = None if not last_anime else last_anime + 1
        if last_anime:
            search_nyaa += f" {next_anime:02}"
        search_nyaa += " 1080p"

        print("\n>", search_nyaa)

        if last_anime and last_anime >= anime.num_episodes:
            print_info("anime already downloaded")
            continue

        results = get_nyaa(search_nyaa)

        if not results:
            print_error("no results found")
            continue

        results = list(filter(
            lambda x: x.is_valid_result(next_anime, anime.title),
            results))

        if not results:
            print_error("no valid results found")
            continue

        print_info(f"{len(results)} results found")

        anime = prompt_torrent(search_nyaa, results)
        if not anime:
            print_info("no magnet selected")
            continue

        if anime.queue_magnet_link():
            print_info("queued magnet link")
        else:
            print_error("failed to queue magnet link")

if __name__ == '__main__':
    main()

# vim: set ft=python:
