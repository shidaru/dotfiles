#!/bin/bash

echo "Start initialize."

packagelist=(
  "bash-completion"
  "curl"
  "dbus-x11"
  "fonts-ricty-diminished"
  "genisoimage"
  "gnome-terminal"
  "imagemagick"
  "ntpdate"
  "openssh-client"
  "source-highlight"
  "vim"
  "wget"
  "gawk"
)

sudo apt update
sudo apt upgrade

for list in ${packagelist[@]}; do
  sudo apt install -y ${list}
done

echo "Apps installed."

eval "./emacs26.sh"

eval "./pyenv.sh"
