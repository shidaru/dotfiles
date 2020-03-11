#!/bin/bash

echo "Ready to pyenv."

git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

sudo apt install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

exec $HOME/.zshrc

NEWER=$(pyenv install --list | grep -v - | grep -v b | tail -1)

pyenv install ${NEWER}

pyenv global ${NEWER}

pip install --upgrade pip

pip install -r $HOME/.dotfiles/requirements.txt

echo "all ready pyenv."
