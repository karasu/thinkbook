#!/bin/sh
FILES=(~/nordic-wallpapers/*.png)
WALLPAPER="${FILES[RANDOM % ${#FILES[@]}]}"

hyprctl hyprpaper unload all > /dev/null
hyprctl hyprpaper preload ${WALLPAPER} > /dev/null
hyprctl hyprpaper wallpaper eDP-1,${WALLPAPER} > /dev/null

