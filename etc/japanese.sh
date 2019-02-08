#!/bin/bash

echo "To Japanese input."

sudo apt install -y fcitx-mozc fonts-noto-cjk x11-xserver-utils

cat << EOS >> $HOME/.profile
export GTK_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export DefaultIMModule=fcitx
xset -r 49
EOS

source $HOME/.profile
