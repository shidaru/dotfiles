#!/bin/bash
# dotfilesのシンボリックリンクを貼る

set -Ceuo pipefail
export LC_ALL=C
export LANG=C

# for file in `ls -d .[^.]*`; do
#   if [ ! $file = ".gitignore" -o ! $file = ".git" ]; then
#     ln -sfnv ./.dotfiles/$file $HOME/$file
#   fi
# done

# ln -sfnv ./.dotfiles/bin $HOME/bin

echo "Finish deploy dotfiles."
echo ""
