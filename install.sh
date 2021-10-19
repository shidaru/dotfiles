#!/bin/bash
# 環境設定を行うスクリプト

set -Ceu
export LC_ALL=C
export LANG=C

DOT_DIR="${HOME}/dotfiles"
REPOSITORY="https://github.com/shidaru/dotfiles"
TARBALL="${REPOSITORY}/tarball/main"
EXPANDED="main.tar.gz"

has() {
    type "$1" > /dev/null 2>&1
}

if [ ! -d ${DOT_DIR} ]; then
    if has "git"; then
      git clone ${REPOSITORY}.git ${DOT_DIR}

    elif has "curl"; then
      curl -L ${TARBALL} -o ${EXPANDED}

    elif has "wget"; then
      wget ${TARBALL} -O ${EXPANDED}

    else
      echo "curl or wget or git required."
      exit 1
    fi

    if [ -d ${EXPANDED} ]; then
      mkdir ${DOT_DIR} && tar zxf ${EXPANDED} -C ${DOT_DIR} --strip-components 1
      rm -rf ${EXPANDED}
    fi
fi

cd ${DOT_DIR}
echo

cd ${DOT_DIR}/bin
./deploy.sh

./init.sh

./docker.sh

echo "Finished Initialize Environment!!"
echo
