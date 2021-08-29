#!/bin/bash
export essential_pacman=(
base
base-devel
bat
bc
clang
curl
ffmpeg
fzf
git
htop
imagemagick
inetutils
jq
less
man-db
man-pages
neofetch
neovim
networkmanager
openssh
p7zip
python
python-pip
rsync
shellcheck
tar
tmux
transmission-cli
tree
unrar
unzip
wget
xdg-user-dirs
youtube-dl
zip
)

export extra_pacman=(
acpi
alacritty
brightnessctl
discord
dunst
feh
firefox
hacksaw
i3-gaps
i3lock
khal
mpv
network-manager-applet
newsboat
libnotify
noto-fonts
pavucontrol
picom
playerctl
pulseaudio
shotgun
socat
sxhkd
sxiv
thunar
trayer
ttf-dejavu
ttf-font-awesome
vdirsyncer
wireless_tools
xclip
xorg-xev
xorg-server
xorg-xdpyinfo
xorg-xinit
xorg-xprop
xorg-xrandr
zathura
zathura-pdf-poppler
)

export all_pacman=( "${essential_pacman[@]}" "${extra_pacman[@]}" )

export essential_repos=(
https://github.com/jtexeira/tiny-aura
)

export extra_repos=(
https://github.com/mendess/dmenu
)

export all_repos=( "${essential_repos[@]}" "${extra_repos[@]}" )

export essential_aur=()

export extra_aur=(
lemonbar-xft-git
thonkbar-git
toilet
)

export all_aur=( "${essential_aur[@]}" "${extra_aur[@]}" )
