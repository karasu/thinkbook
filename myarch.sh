# Arch install script with my favourites

aur() {
  echo "Installing $1 from AUR..."
  git clone https://aur.archlinux.org/$1.git
  cd $1
  makepkg -s
  ${INSTALL_ZST} *.zst
  cd ..
}

set_vars() {
  USERNAME="karasu"
  CONF_DIR="/home/${USERNAME}/.config"

  INSTALL_DEV="/dev/nvme0n1"
  BOOT_PART="/dev/nvme0n1p1"
  ROOT_PART="/dev/nvme0n1p2"

  PARTED="parted -s -f -a optimal"

  EAP_IDENTITY="W08044624"
  EAP_PASSWORD=""

  PACMAN="pacman -S --needed --noconf"
  INSTALL_ZST="pacman -U --needed --noconf"

  YAY="yay -S --needed --noconf"

  PROGRAMARI_USERNAME="compartit"
  PROGRAMARI_PASSWORD=""

  export EDITOR=nano
}

prepare_disk() {
  ${PARTED} ${INSTALL_DEV} -- mklabel gpt \
    mkpart myboot fat32 1MiB 512MiB \
    mkpart myroot btrfs 512MiB -1s

  # Create filesystems
  mkfs.vfat ${BOOT_PART}
  mkfs.btrfs ${ROOT_PART}

  # Mount install destination
  mkdir /mnt
  mount ${ROOT_PART} /mnt

  mkdir /mnt/boot
  mount ${BOOT_PART} /mnt/boot
}

base_system() {
  # Install base systemm
  pacstrap /mnt base base-devel linux linux-firmware btrfs-progs intel-ucode intel-media-driver

  # Setup /etc/fstab
  genfstab -U /mnt >> /mnt/etc/fstab

  # Chroot into new installed system
  arch-chroot /mnt

  # Install firmwares
  ${PACMAN} linux-firmware-bnx2x linux-firmware-liquidio linux-firmware-mellanox \
    linux-firmware-nfp linux-firmware-qlogic linux-firmware-whence aic94xx-firmware \
    mkinitcpio-firmware sof-firmware wd719x-firmware                   

  # Install some base tools
  ${PACMAN} grub nano sudo dhcpcd greetd iwd os-prober ntfs-3g git wget curl

  # zsh
  ${PACMAN} zsh zsh-completions powerline zsh-autosuggestions \
    zsh-syntax-highlighting zsh-powerlevel10k lsd
}

locales() {
  # Generate locales
  sed 's/#en_US.UTF8 UTF-8/en_US.UTF8 UTF-8/g' /etc/locale.gen
  sed 's/#ca_ES.UTF8 UTF-8/ca_ES.UTF8 UTF-8/g' /etc/locale.gen

  locale-gen
  localectl set-locale ca_ES.UTF8

  ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
  hwclock --systohc
}

bootloader() {
  # Install bootloader
  grub-install ${INSTALL_DEV}
  grub-mkconfig -o /boot/grub/grub.cfg
}

users() {
  # Users
  echo "Set root password:"
  passwd
  echo "Set password for ${USERNAME}:"
  useradd -m -g users -G wheel -s /bin/zsh ${USERNAME}
  passwd ${USERNAME}

  # Add group wheel to sudoers
  sed 's/# %wheel/%wheel/g' /etc/sudoers
}

enable_services() {
  systemctl enable dhcpcd
  systemctl enable greetd
}

wifi() {
  # iwd (wifi)
  echo "[Security]
  EAP-Method=PEAP
  EAP-Identity=${EAP_IDENTITY}
  EAP-PEAP-Phase2-Method=MSCHAPV2
  EAP-PEAP-Phase2-Identity=${EAP_IDENTITY}
  EAP-PEAP-Phase2-Password=${EAP_PASSWORD}
  [Settings]
  AutoConnect=true" > /var/lib/iwd/gencat_ENS_EDU.8021x
}

yay() {
  aur yay
}

session() {
  # greetd
  ${PACMAN} greetd

  echo '[terminal]
  vt = 1

  [default_session]
  command = "tuigreet --cmd hypr"
  user = "greeter"' >> /etc/greetd/config.toml

  aur greetd-tuigreet-bin
}

hyprland() {
  ${PACMAN} base-devel gdb ninja gcc cmake libxcb xcb-proto xcb-util \
    xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender \
    pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm \
    xorg-xwayland cmake wlroots mesa git meson polkit lxqt-policykit wofi \
    waybar jq wayland-utils wdisplays

  aur hyprland-bin

  # Install Hyprpaper
  git clone https://github.com/hyprwm/hyprpaper  
  cd hyprpaper  
  make all  
  sudo cp build/hyprpaper /usr/local/bin 
  cd ..

  # Copy hyprland conf
  mkdir -p ${CONF_DIR}/hypr
  cp -Rv hypr/* ${CONF_DIR}/hypr

  ${PACMAN} kitty zathura openssh p7zip

  ${PACMAN} pop-icon-theme capitaine-cursors breeze-icons

  aur fantome-gtk

  aur nitch

  gsettings set org.gnome.desktop.interface icon-theme Pop  
  #gsettings set org.gnome.desktop.interface gtk-theme Fantome
  gsettings set org.gnome.desktop.interface cursor-theme capitaine-cursors

  ${PACMAN} qt5-wayland
}

audio() {
  # alsa (audio)
  ${PACMAN} alsa-lib alsa-plugins alsa-tools alsa-utils alsa-firmware
  gpasswd -a ${USERNAME} audio

  # pipewire (audio)
  ${PACMAN} pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack

  # openal
  ${PACMAN} openal realtime-privileges

  # Multimedia graph framework
  ${PACMAN} gst-plugin-pipewire gst-plugins-base gst-plugins-bad gst-plugins-good \
    gst-plugins-ugly

  ${PACMAN} pavucontrol
}

fonts() {
  ${PACMAN} adobe-source-code-pro-fonts awesome-terminal-fonts cantarell-fonts \
    gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    siji-ttf ttf-dejavu ttf-font-awesome ttf-font-icons ttf-ionicons \
    ttf-liberation ttf-ms-win10-auto ttf-opensans ttf-sourcecodepro-nerd \
    ttf-unicons ttf-hack powerline-fonts ttc-iosevka

  cp -v Madness.ttf /usr/share/fonts/TTF
}

apps() {
  aur gimp-devel
  aur github-desktop-bin
  aur google-chrome

  ${PACMAN} grim ffmpegthumbnailer gnome-tweaks jre-openjdk lxqt-policykit \
    mesa-utils vulkan-intel mlocate moc mpv mtools nfs-utils \
    youtube-dl zathura-pdf-poppler zathura imv

  ${PACMAN} zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting \
    zsh-theme-powerlevel10k

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

wine() {
${PACMAN} wine-staging winetricks
}

autofs() {
  ${PACMAN} autofs
  systemctl enable autofs
  cp autofs/auto.master.d/programari.autofs /etc/autofs/auto.master.d
  echo "programari -fstype=cifs,username=${PROGRAMARI_USERNAME},password=${PROGRAMARI_PASSWORD} ://192.168.0.151/programari" > /etc/autofs/auto.programari
  echo "operatius -fstype=cifs,username=${PROGRAMARI_USERNAME},password=${PROGRAMARI_PASSWORD} ://192.168.0.151/operatius" >> /etc/autofs/auto.programari
}

scripts() {
  cp -v scripts/* /usr/local/bin
}

# ####################################################################################

set_vars()

#prepare_disk()

base_system()
locales()
bootloader()
users()
enable_services()
wifi()
yay()
session()
hyprland()
audio()
fonts()
apps()
wine()
autofs()
scripts()

