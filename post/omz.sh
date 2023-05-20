#!/bin/sh

# Just in case
pacman -Sy --noconfirm --needed zsh

echo "Installing OH MY ZSH..."

USR=`id -un 1000`
chsh -s /bin/zsh $USR
chsh -s /bin/zsh root

wget -O /tmp/omzsh-install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
chmod +x /tmp/omzsh-install.sh

# Install for root
/tmp/omzsh-install.sh

# Install for user 1000
sudo -u $USR /tmp/omzsh-install.sh


