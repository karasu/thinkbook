#!/bin/sh

# Set user password

USR=`id -nu 1000`
echo "Enter user $USR password:"
passwd $USR

###################################################################################
# Installs AUR helper

YAY="/thinkbook/yay"

echo "Installing yay using $USR user..."
pacman -Sy --needed --noconfirm go
git clone https://aur.archlinux.org/yay.git $YAY
chown -R $USR:$USR $YAY
cd $YAY
su -c 'makepkg -f --needed --noconfirm' $USR
pacman -U --needed --noconfirm yay-*-x86_64.pkg.tar.zst

###################################################################################
echo "Adding chaotic-aur repository to pacman..."

pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U --needed --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

###################################################################################
# Fonts

pacman -Sy --needed --noconfirm awesome-terminal-fonts \
  cantarell-fonts gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji \
  noto-fonts-extra ttf-dejavu ttf-font-awesome ttf-ionicons ttf-liberation ttf-opensans \
  ttf-ubuntu-font-family ttf-ubuntu-mono-nerd ttf-ubuntu-nerd ttf-sourcecodepro-nerd \
  ttf-hack powerline-fonts ttc-iosevka ttf-jetbrains-mono-nerd

pacman -Sy --needed --noconfirm siji-ttf
# ttf-font-icons ttf-unicons

##################################################################################
# Installs zsh, omyzsh and starship

pacman -Sy --noconfirm --needed zsh starship

echo "Installing OH MY ZSH..."

chsh -s /bin/zsh $USR
chsh -s /bin/zsh root

wget -O /tmp/omzsh-install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
chmod +x /tmp/omzsh-install.sh

# Install for root
/tmp/omzsh-install.sh

# Install for user 1000
sudo -u $USR /tmp/omzsh-install.sh

# Install starship cross-shell
sudo pacman -Sy --noconfirm --needed starship
mkdir -p /root/.config /home/$USR/.config
starship preset pastel-powerline -o /root/.config/starship.toml
cp /root/.config/starship.toml /home/$USR/.config
chown $USR:$USR /home/$USR/.config/starship.toml

#################################################################################
# Install AUR packages

pacman -Sy --needed --noconfirm jq

PACKAGES=`jq '.aur[]' /thinkbook/aur.json`

for package in ${PACKAGES[@]}
do
  sudo -u $USR -- yay -S --needed --noconfirm $package
done

################################################################################
# Copy dot files

mv /thinkbook/disk/home/user /thinkbook/disk/home/$USR
cp -Rnv /thinkbook/disk/* /

###############################################################################
# clean conflicting portals
yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
