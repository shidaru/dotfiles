#!/bin/bash
# 環境設定を行うスクリプト

set -Ceu
export LC_ALL=C
export LANG=C

DOT_DIR="${HOME}/dotfiles"
REPOSITORY="https://github.com/shidaru/dotfiles"
TARBALL="${REPOSITORY}/archive/main.tar.gz"

has() {
    type "$1" > /dev/null 2>&1
}

if [ ! -d ${DOT_DIR} ]; then
    if has "git"; then
        git clone ${REPOSITORY}.git ${DOT_DIR}

    elif has "curl"; then
        curl -L ${TARBALL} -o main.tar.gz
    elif has "wget"; then
        wget ${TARBALL}
    else
        echo "curl or wget or git required."
        exit 1
    fi

    if [ -d main.tar.gz ]; then
        tar -zxvf main.tar.gz
        rm -rf main.tar.gz
        mv -f dotfiles-main "${DOT_DIR}"
    fi
fi

cd ${DOT_DIR}
echo

cd ${DOT_DIR}/bin
./deploy.sh

./init.sh

./docker.sh
