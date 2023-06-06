#!/bin/sh
ln -s /var/lib/pacman/sync/*.db /var/cache/pacman/pkg/
python -m http.server -d /var/cache/pacman/pkg/
