#!/bin/bash
# dotfilesのシンボリックリンクを貼る

set -Ceu
export LC_ALL=C
export LANG=C

DOT_DIR="${HOME}/dotfiles"

echo "Deploy dotfiles."
echo

for file in $(ls -A ${DOT_DIR} | grep -e "^\..\+$"); do
  if [[ ${file} == ".gitignore" ]]; then
    continue
  fi

  target=${DOT_DIR}/${file}

  ln -sfnv ${target} $HOME/$file

  echo "${file} is deployed."
done
echo

echo "Finish deploy dotfiles."
echo
