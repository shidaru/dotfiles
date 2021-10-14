#!/bin/bash
# $HOME以下のdotfilesシンボリックリンクを削除する

set -Ceu
export LC_ALL=C
export LANG=C

DOT_DIR="${HOME}/dotfiles"

echo "Undeploy dotfiles."
echo

for file in $(ls -al ${HOME} | grep '^l' | awk '{print $9}'); do
    if [[ ${file} == ".gitignore" ]]; then
        continue
    fi

    target=${HOME}/${file}
    unlink ${target}

    echo "${target} is undeployed."
done

echo "Finish undeploy dotfiles."
echo
