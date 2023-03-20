#!/bin/python3
""" convert [fetch](toolbox/fetch.tool) logos to png """

from os import listdir, path
from pathlib import Path
import sys
import subprocess

from PIL import Image, ImageColor

background_color = (0,0,0,0)

DEST_FOLDER="./"
if len(sys.argv) > 1:
    DEST_FOLDER = sys.argv[1]

config_dir=f"{Path.home()}/.config/neofetch"

def get_property(field: str):
    """ get Xresources field """
    with subprocess.Popen(["xrdb", "-get", field], stdout=subprocess.PIPE) as process:
        output, error = process.communicate()

        if error:
            return None

        return output.decode("utf-8").rstrip()

def hex2rgb(hexcolor: str):
    """ Convert a HTML color string to RGBA """
    return ImageColor.getcolor(hexcolor, "RGBA")


# generate colorscheme from Xresources
color_scheme={}
for i in range(16):
    color=get_property(f"color{i}")

    if not color:
        print(f"color{i} not found")
        sys.exit()
    color_scheme[f"{i}"] = hex2rgb(color)

# generate images
for icon in [x.split(".")[0] for x in listdir(f"{config_dir}/ascii")]:
    ascii_file=f"{config_dir}/ascii/{icon}.ascii"
    color_file=f"{config_dir}/colors/{icon}.colors"

    target_file=f"{DEST_FOLDER}/computer-{icon}.png"

    if path.exists(target_file):
        continue

    color_key={}
    with open(color_file, "r", encoding="utf-8") as file:
        colors = file.readlines()[0].split("=")[1].replace("(", "").replace(")", "").split()
        for i in range(6):
            color_key[f"{i+1}"] = colors[i]


    parsed_ascii=[]
    with open(ascii_file, "r", encoding="utf-8") as file:
        curr_color=(0,0,0,0)
        for line in file.readlines():
            line = line.rstrip()
            result = []
            while len(line) > 0:
                match line[0]:
                    case "█":
                        result.append(curr_color)
                        line = line[1:]
                    case " ":
                        result.append(background_color)
                        line = line[1:]
                    case "$":
                        curr_color=color_scheme[color_key[line[3]]]
                        line = line[5:]
                    case _:
                        print("error")
                        sys.exit()
            parsed_ascii += [result] * 2

    # normalize list of lists
    max_len = max(map(len, parsed_ascii))
    parsed_ascii = [i + [background_color]*(max_len-len(i)) for i in parsed_ascii]

    # convert to image
    image = Image.new("RGBA", (max_len, len(parsed_ascii)))
    image.putdata([i for s in parsed_ascii for i in s])

    # upsacle image
    width, height = image.size
    n_width = min(round(width/height * 512), 512)
    n_height = min(round(height/width * 512), 512)
    upscaled_image = image.resize((n_width, n_height), resample=Image.Resampling.BOX)

    # add border to image
    new_size = (512, 512)
    new_im = Image.new("RGBA", new_size, background_color)
    box = tuple((n - o) // 2 for n, o in zip(new_size, (n_width, n_height)))
    new_im.paste(upscaled_image, box)

    new_im.save(target_file)
    print("> generated:", icon)

# vim: set ft=python:
