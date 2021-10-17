#!/bin/bash

set -Ceu
export LC_ALL=C
export LANG=C

packagelist=(
  "cmigemo"
  "curl"
  "dbus-x11"
  "elpa-color-theme-modern"
  "emacs"
  "emacs-mozc"
  "fonts-firacode"
  "genisoimage"
  "git"
  "imagemagick"
  "language-pack-ja"
  "ntpdate"
  "openssh-client"
  "python-is-python3"
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

# localeを変更する
echo "Change default locale."
echo
sudo update-locale LANG=ja_JP.UTF-8

echo "Changed default locale."
echo
