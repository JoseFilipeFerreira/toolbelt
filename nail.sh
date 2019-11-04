#!/bin/bash
DOTF=$(pwd)
sed -i -r 's|DOTFILES=.*|DOTFILES='"$DOTF"'|g' zsh/zprofile
sed -i -r 's|set $configs.*|set $configs '"$DOTF"'|g' i3/config
export DOTFILES=$DOTF

