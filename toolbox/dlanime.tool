#!/bin/python3
"""TUI to download from [nyaa](https://nyaa.si) based on data from [MAL](https://myanimelist.net)"""
from dataclasses import dataclass
from enum import Enum
from json import loads
from pathlib import Path
from subprocess import PIPE, Popen
from typing import List, Optional
from urllib.parse import urlencode
import os
import re
import socket
import sys

import requests
from bs4 import BeautifulSoup
from qbittorrent import Client # type: ignore

def print_info(string: str):
    """print information"""
    print(f"[\033[34minfo\033[0m] {string}")

def print_error(string: str):
    """print errors"""
    print(f"[\033[31merror\033[0m] {string}")

def print_warn(string: str):
    """print warnings"""
    print(f"[\033[33mwarning\033[0m] {string}")

def print_success(string: str):
    """print information"""
    print(f"[\033[32msuccess\033[0m] {string}")

def check_if_valid(dirname: str):
    """check if a folder exists"""
    if not os.path.isdir(dirname):
        print_error(f"Location does not exist: {dirname}")
        sys.exit()

ANIME_LOCATION = "/mnt/media/anime"
check_if_valid(ANIME_LOCATION)

@dataclass
class NyaaResult():
    """Class for Nyaa result"""
    title: str
    nyaa_id: str
    magnet: str
    size: str
    seeders: int
    leechers: int
    completed: int

    def quality_score(self):
        """Give a quality score to the Torrent"""
        priority_sources=["SubsPlease", "Erai-raws", "HorribleSubs"]
        for i, source in enumerate(priority_sources):
            if self.title.startswith(f"[{source}]"):
                return len(priority_sources) - i
        return -1

    def __lt__(self, other):
        return self.quality_score() < other.quality_score()

    def is_valid_result(self, episode: Optional[int], searched_title: str) -> bool:
        """check if self is valid result"""


        if not all(x in self.title.lower() for x in searched_title.lower().split()):
            return False

        if not episode:
            return True

        matches = re.findall(r'\[[ 0-9a-zA-Z]+\]', self.title)
        clean_title = self.title
        for match in matches:
            clean_title = clean_title.replace(match, "")

        episode_str = str(episode).rjust(2, '0')

        if re.search(f' {episode_str} ', clean_title):
            return True

        if re.search(f'S[0-9]+E{episode_str}', clean_title):
            return True

        return False

    def queue_magnet_link(self):
        """queue magnet link"""

        soc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        soc.connect(("8.8.8.8", 80))
        local_ip = soc.getsockname()[0]

        client = Client(f'http://{local_ip}:8090/')

        out = client.download_from_link(self.magnet, category="dlanime")

        if out == "Fails.":
            return None

        return self.magnet

class AiringStatus(Enum):
    """status in MAL"""
    AIRING = 1
    FINISHED_AIRING = 2
    NOT_YET_AIRED = 3

@dataclass
class MalResult():
    """Class for MyAnimeList result"""
    # pylint: disable=too-many-instance-attributes

    airing_status: AiringStatus
    mal_id: int
    image_path: str
    num_episodes: int
    num_watched_episodes: int
    title: str
    clean_title: str
    anime_path: str
    url: str

    def __init__(self, dic):
        self.mal_id = dic['id']
        self.image_path = dic['image_path']
        self.num_episodes = dic['num_episodes']
        self.num_watched_episodes = dic['num_watched_episodes']
        self.title = dic['title']
        self.url = dic['url']
        self.airing_status = AiringStatus(dic['airing_status'])

        remove = ['!', '.', ':', '"', '?']
        self.clean_title = self.title.translate({ord(x): '' for x in remove})
        for char in ["☆"]:
            self.clean_title = self.clean_title.replace(char, " ")
        self.anime_path = ANIME_LOCATION + "/" + self.clean_title

    def mkdir(self):
        """create directory for anime"""
        if not os.path.exists(self.anime_path):
            Path(self.anime_path).mkdir(parents=True, exist_ok=True)
            print_info(f"created folder:{self.anime_path}")

    def download_thumb(self) -> bool:
        """download image in url"""
        path = self.anime_path + "/poster.jpg"

        if os.path.exists(path):
            return True

        print_info("downloading image: " + path)
        try:
            url = "http://myanimelist.net" + self.url
            request = requests.get(url, timeout=10)
        except requests.ReadTimeout:
            print_error("Read timeout for Nyaa full image url")
            return False

        soup = BeautifulSoup(request.content, "html.parser")
        image_url = soup.find("img", {"class", "ac"})["data-src"]

        os.makedirs(os.path.dirname(path), exist_ok=True)

        response = requests.get(image_url, timeout=10)
        if response.status_code == 200:
            with open(path, 'wb') as file:
                file.write(response.content)
            return True

        print_error("could not download image")
        return False

class ListType(Enum):
    """possible media status in MAL"""
    WATCHING = 1
    COMPLETED = 2
    ONHOLD = 3
    DROPPED = 4
    PLAN2WATCH = 6

class MediaType(Enum):
    """possible media types in MAL"""
    ANIME = "animelist"
    MANGA = "mangalist"

def get_mal(
        user: str,
        media: MediaType = MediaType.ANIME,
        state: ListType = ListType.WATCHING) -> Optional[List[MalResult]]:
    """get list of all media from user"""
    try:
        url = f'https://myanimelist.net/{media.value}/{user}?status={state.value}'
        request = requests.get(url, timeout=10)
    except requests.ReadTimeout:
        print_error("MAL request timed out")
        return None


    soup = BeautifulSoup(request.content, "html.parser")
    table = soup.find('table', {"class", "list-table"})

    if not table:
        return None

    res = []
    for line in loads(table['data-items']):
        res.append(
            MalResult(
                {k.replace(media.name.lower() + "_", ""): v for k, v in line.items()}))

    return res

def get_nyaa(title: str) -> Optional[List[NyaaResult]]:
    """get nyaa's search result"""
    try:
        get_vars = {'f': 0, 'c': '1_2', 'q': f"{title}"}
        url = f"https://nyaa.si/?{urlencode(get_vars)}"
        request = requests.get(url, timeout=10)
    except requests.ReadTimeout:
        print_error(f"Nyaa timedout for: {title}")
        return None

    soup = BeautifulSoup(request.content, "html.parser")
    table = soup.find('table')

    if not table:
        return None

    content = table.find('tbody')

    if not content:
        return None

    res = []
    for line in content.find_all('tr'):
        line_vec = line.find_all('td')
        res.append(
            NyaaResult(
                title=line_vec[1].find_all('a')[-1]['title'],
                nyaa_id=line_vec[1].find_all('a')[-1]['href'],
                magnet=line_vec[2].find_all('a')[1]['href'],
                size=line_vec[3].contents[0],
                seeders=line_vec[5].contents[0],
                leechers=line_vec[6].contents[0],
                completed=line_vec[7].contents[0]))
    return res

def get_last_episode(anime_path: str) -> Optional[int]:
    """get number of last downloaded episode"""
    dl_animes = os.listdir(anime_path)
    dl_animes.sort(reverse=True)
    dl_animes.remove("poster.jpg")

    if len(dl_animes) == 0:
        return 0

    try:
        grep = re.search(r'E([0-9]+?)\.', dl_animes[0])
        if grep:
            return int(grep.group(1))
        raise ValueError
    except ValueError:
        print_error(f"invalid filename: {dl_animes[0]}")
        return None

def prompt_fzf(header: str, content: List[str]) -> Optional[str]:
    """prompt user with fzf"""
    with Popen(
        ["fzf", "--cycle", f"--header='{header}'"],
        stdout=PIPE,
        stdin=PIPE,
        encoding="utf-8"
    ) as proc:
        output, error = proc.communicate("\n".join(content)+"\n")

        if error:
            return None
        if not output:
            return None

        return output.strip()

def prompt_torrent(name: str, content: List[NyaaResult]) -> Optional[NyaaResult]:
    """prompt user to choose a torrent file"""
    out = prompt_fzf(f"search: {name}", [x.title for x in content])

    if not out:
        return None

    anime = list(filter(lambda x: x.title == out, content))

    return None if not anime else anime[0]

def get_results(anime: MalResult) -> Optional[List[NyaaResult]]:
    """get filtered results of Nyaa"""

    search_nyaa = anime.clean_title
    last_episode = get_last_episode(anime.anime_path)
    if last_episode is None:
        return None
    next_episode =  last_episode + 1
    if last_episode > 0:
        search_nyaa += f" {next_episode:02}"
    search_nyaa += " 1080p"

    if last_episode:
        print("> episode:", last_episode, "/", anime.num_episodes)

    if last_episode and anime.num_episodes > 0 and last_episode == anime.num_episodes:
        print_info("anime already downloaded")
        return None

    # print(">", search_nyaa)

    results = get_nyaa(search_nyaa)

    if not results:
        print_warn("no results found")
        return None

    results = list(filter(
        lambda x: x.is_valid_result(next_episode, anime.clean_title),
        results))

    if not results:
        print_warn("all results were removed")
        return None

    print_info(f"{len(results)} results found")

    results.sort(reverse=True)

    return results

def main():
    """entrypoint"""
    print_info("fetching animes from user")
    animes = get_mal("nifernandes")

    if not animes:
        print_error("failed to get list of animes from user")
        return

    for anime in animes:
        print("\n>", anime.title)
        if anime.airing_status == AiringStatus.NOT_YET_AIRED:
            print_error("anime not yet aired")
            continue

        image = anime.download_thumb()
        if not image:
            print_error("Failed to download image")
            continue

        anime.mkdir()

        results = get_results(anime)
        if not results:
            continue

        nyaa = None
        if results[0].quality_score() > 0:
            print_success(f"found {results[0].title}")
            nyaa = results[0]
        else:
            nyaa = prompt_torrent("pick torrent", results)

        if not nyaa:
            print_warn("no magnet selected")
            continue

        if nyaa.queue_magnet_link():
            print_success("queued magnet link")
        else:
            print_error("failed to queue magnet link")

if __name__ == '__main__':
    main()

# vim: set ft=python:
