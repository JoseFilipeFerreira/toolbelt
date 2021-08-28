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
nodejs
openssh
python
python-pip
rsync
shellcheck
tmux
transmission-cli
unzip
wget
xclip
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
pavucontrol
picom
pulseaudio
shotgun
socat
sxhkd
sxiv
ttf-dejavu
vdirsyncer
wireless_tools
xorg-server
xorg-xinit
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
