#!/bin/bash
# convert list of urls to opml and filter categories

file=~/.config/newsboat/urls
[[ "$1" ]] && file="$1"

newsboat --export-to-opml --url-file="$file" | grep -Ev 'xmlUrl="---.*---"'
