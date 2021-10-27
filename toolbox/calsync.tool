#!/bin/bash
# Sync calendar with vdirsyncer
vdirsyncer discover calendar
vdirsyncer metasync --max-workers=1
vdirsyncer sync calendar
