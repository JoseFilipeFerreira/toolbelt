#!/bin/python
"""Convert a value inside a numeric range to a color inside a color range"""

import argparse
import colorsys

from typing import Tuple

parser = argparse.ArgumentParser(
    prog='range2color',
    description='Convert a value inside a numeric range to a color inside a color range')

parser.add_argument('value', type=float, help="value inside the numeric range")
parser.add_argument('--min', default=0, type=float, help="minimum value of the numeric range")
parser.add_argument('--max', default=100, type=float, help="maximum value of the numeric range")
parser.add_argument('--min-color', default="#E82424", help="minimum value of the color range", metavar="#RRGGBB")
parser.add_argument('--max-color', default="#98BB6C", help="maximum value of the color range", metavar="#RRGGBB")
parser.add_argument('--display', action='store_true', help="display the color range as a image for debug purposes")

args = parser.parse_args()


def map_range(input: float, input_start: float, input_end: float, output_start: float, output_end: float) -> float:
    """map a value inside a range into another range"""
    return output_start + ((output_end - output_start) / (input_end - input_start)) * (input - input_start)

def hex_to_rgb(value: str) -> Tuple[float, float, float]:
    """convert hex color to rgb"""
    value = value.lstrip('#')
    lv = len(value)
    r, g, b = tuple(int(value[i:i + lv // 3], 16)/256 for i in range(0, lv, lv // 3))
    return (r, g, b)

min_h, min_l, min_s = colorsys.rgb_to_hls(*hex_to_rgb(args.min_color))
max_h, max_l, max_s = colorsys.rgb_to_hls(*hex_to_rgb(args.max_color))

if args.display:
    from PIL import Image, ImageDraw

    size=512

    image = Image.new(mode="RGB", size=(size, size), color=(0,0,0))
    draw = ImageDraw.Draw(image)
    for i in range (0,size):
        h = map_range(i, 0, size, min_h, max_h)
        l = map_range(i, 0, size, min_l, max_l)
        s = map_range(i, 0, size, min_s, max_s)

        r, g, b= tuple(int(x*256) for x in colorsys.hls_to_rgb(h, l, s))
        for c in range(0,size):
            draw.point((i,c), (r,g,b))

    image.show()

h = map_range(args.value, args.min, args.max, min_h, max_h)
l = map_range(args.value, args.min, args.max, min_l, max_l)
s = map_range(args.value, args.min, args.max, min_s, max_s)

print('#{:02x}{:02x}{:02x}'.format(*[int(x*256) for x in colorsys.hls_to_rgb(h, l, s)]))

# vim: set ft=python:
