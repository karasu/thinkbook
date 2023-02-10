#!/usr/bin/env bash
filename="$HOME/screenshots/$(date +'%Y.%m.%d-%H:%m:%S').png"
touch $filename
grim $filename
