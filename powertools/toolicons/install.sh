#!/bin/bash
if [[ "$1" == check ]]; then
    ~/.local/bin/icons --check
else
    ~/.local/bin/icons --generate
fi
