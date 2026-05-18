#!/bin/python3
from typing import List
import sys
from subprocess import PIPE, Popen
import subprocess

films = [
    "Agfa APX 100",
    "Cinestill 400D",
    "Fujifilm C200",
    "Fujifilm Superia Xtra 400",
    "Ilford XP2",
    "Kodak Gold 200",
    "Kodak Portra 160",
    "Kodak Portra 400",
    "Kodak Portra 800",
    "Kodak ProImage 100",
    "Kodak Ultramax 400",
    "Lomography Berlin",
    "Lomography Lady Grey",
    "Lomography Metropolis",
    "Lomography Potsdam",
    "Lomography Purple",
    "Rollei Infrared 400"
]


cameras = {
    "Minolta XD5": {
        "make": "Minolta",
        "model": "XD5",
        "lenses": [
            "Minolta MD 50mm f/2"
        ]
    },
    "Nikon FM2": {
        "make": "Nikon",
        "model": "FM2",
        "lenses": [
            "Nikkor AF-D 28mm f/2.8",
            "Nikkor AF-D 50mm f/1.4"
        ]
    },
    "Olympus AF-1 Mini": {
        "make": "Olympus",
        "model": "AF-1 Mini",
        "lenses": [
            "Olympus Lens AF 35mm f/3.5"
        ]
    },
    "Olympus Pen FT": {
        "make": "Olympus",
        "model": "Pen FT",
        "lenses": [
            "Olympus E.Zuiko Auto-W 25mm f/4"
        ]
    },
    "Minolta Dynax 500si": {
        "make": "Minolta",
        "model": "Dynax 500si",
        "lenses": [
            "Minolta Maxxum AF 50mm F/1.7"
        ]
    },
    "Lomography Diana Mini": {
        "make": "Lomography",
        "model": "Diana Mini",
        "lenses": [
            "Lomography 24mm f/8 f/11"
        ]
    }

}


scanners = [
    "Nikon Coolscan V ED"
]

def select(header: str, content: List[str]) -> str:
    """prompt user with fzf"""
    if not content:
        sys.exit(1)

    if len(content) == 1:
        return content[0]

    with Popen(
        ["fzf", "--cycle", f"--header={header}"],
        stdout=PIPE,
        stdin=PIPE,
        text=True
    ) as proc:
        output, _ = proc.communicate("\n".join(content)+"\n")

        if proc.returncode != 0 or not output:
            sys.exit(1)

        return output.strip()

files = sys.argv[1:]

if len(files) < 1:
    print("No files provided")
    sys.exit(1)

camera  = select("📷 Camera",  list(cameras.keys()))
lens    = select("🔎 Lens",    cameras[camera]["lenses"])
film    = select("🎞️ Film",    films)
scanner = select("🖨 Scanner", scanners)

make    = cameras[camera]["make"]
model   = cameras[camera]["model"]


for f in files:
    print(f)

print("EXIF:Make       ", make)
print("EXIF:Model      ", model)
print("EXIF:LensModel  ", lens)
print("XMP:Description ", f"Film {film}; Camera {camera}; Lens {lens}; Scanner {scanner}")

subprocess.run(
    [
        "exiftool",
        "-overwrite_original",
        "-P",
        f"-Make={make}",
        f"-Model={model}",
        f"-LensModel={lens}",
        f"-XMP:Description=Film {film}; Camera {camera}; Lens {lens}; Scanner {scanner}",
        *files
    ],
    check=True)
