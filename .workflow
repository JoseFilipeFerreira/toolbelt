#!/bin/bash
export essential_pacman=(
base
base-devel
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
rsync
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
termite
ttf-dejavu
vdirsyncer
xorg-server
xorg-xinit
zathura
zathura-pdf-poppler
)

export all_pacman=( "${essential_pacman[@]}" "${extra_pacman[@]}" )

export essential_repos=(
https://github.com/jtexeira/tiny-aura
)

export extra_repos=(
https://github.com/JoseFilipeFerreira/thonkbar
https://github.com/mendess/dmenu
)

export all_repos=( "${essential_repos[@]}" "${extra_repos[@]}" )
