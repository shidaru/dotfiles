#!/bin/bash
# ドットファイルのシンボリックリンクを貼る

for file in `ls -d .[^.]*`; do
  if [ ! $file = ".gitignore" ]; then
    ln -sfnv ./.dotfiles/$file $HOME/$file
  fi
done

ln -sfnv ./.dotfiles/bin $HOME/bin

echo "Finish deploy dotfiles."
