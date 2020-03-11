#!/bin/bash

set -Ceuo pipefail
export LC_ALL=C
export LANG=C

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Install libraries."
echo $(pwd)

packagelist=(
  "bash-completion"
  "curl"
  "dbus-x11"
  "fonts-ricty-diminished"
  "genisoimage"
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
