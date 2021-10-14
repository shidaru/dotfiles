#!/bin/bash

set -Ceu
export LC_ALL=C
export LANG=C

packagelist=(
    "curl"
    "dbus-x11"
    "emacs"
    "fonts-firacode"
    "genisoimage"
    "git"
    "imagemagick"
    "ntpdate"
    "openssh-client"
    "source-highlight"
    "vim"
    "wget"
    "zip"
    "zsh"
)

sudo apt update
sudo apt upgrade -y

for list in ${packagelist[@]}; do
    sudo apt install -y ${list}
done

echo "Apps installed."
echo

echo "Login shell changes to zsh."
echo
chsh -s $(which zsh)
