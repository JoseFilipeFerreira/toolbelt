#!/bin/bash
# Sync calendar with vdirsyncer
vdirsyncer discover calendar
vdirsyncer metasync
vdirsyncer sync calendar
