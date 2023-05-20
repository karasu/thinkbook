#!/bin/sh

# Just in case
pacman -Sy --noconfirm --needed zsh

echo "Installing OH MY ZSH..."

USR=`id -un 1000`
chsh -s /bin/zsh $USR
chsh -s /bin/zsh root

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
su -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" $USR


