#!/bin/bash


echo "Start install emacs26."

mkdir -p $HOME/tmp
cd $HOME/tmp

git init
git remote add origin https://github.com/emacs-mirror/emacs.git
git fetch --depth 1 origin emacs-26
git reset --hard FETCH_HEAD
sudo apt install -y autoconf make gcc texinfo libgtk-3-dev libxpm-dev libjpeg-dev libgif-dev libtiff5-dev libgnutls28-dev libncurses5-dev build-essential emacs-mozc-bin

./configure --without-xim --with-sound=no --with-x --without-toolkit-scroll-bars
make
sudo make install

rm -rf $HOME/tmp

echo "Finish."
