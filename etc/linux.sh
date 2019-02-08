#!/bin/bash

# install packages
packagelist=(
  "imagemagick"
  "curl"
  "gcc"
  "make"
  "sudo"
  "ntpdate"
  "vim"
  "wget"
  "zlibc"
  "zlib1g-dev"
  "xdg-user-dirs-gtk"
)

sudo apt update

sudo apt build-dep -y linux

echo "Start install apps."
for list in ${packagelist[@]}; do
  sudo apt install -y ${list}
done

# Docker環境
eval ./etc/docker.sh
