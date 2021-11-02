#!/bin/bash
# Sync calendar with vdirsyncer
if [[ "$1" = "discover" ]]; then
    vdirsyncer discover calendar
    vdirsyncer discover contacts
    vdirsyncer metasync
fi
vdirsyncer sync calendar
vdirsyncer sync contacts
