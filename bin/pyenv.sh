#!/bin/bash
# pyenvをセットアップ

set -Ceu
export LC_ALL=C
export LANG=C

echo "Install pyenv."
echo


git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

sudo apt install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

source $HOME/.bashrc

VERSION=3.9.7

pyenv install ${VERSION}

pyenv global ${VERSION}

source $HOME/.bashrc

INSTALLED_VERSION=$(python -V | awk '{print $2}')

if [[ ${VERSION} != ${INSTALLED_VERSION} ]]; then
    echo "Install is failed."
    echo
    exit 1
fi

python -m pip install --upgrade pip

echo "all ready pyenv."
echo
