#!/bin/bash

echo "Ready to pyenv."

# git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

# sudo apt-get install -y gcc make libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev

NEWER=$(pyenv install --list | grep -v - | grep -v b | tail -1)

# pyenv install ${NEWER}

# pyenv global ${NEWER}

# pip install --upgrade pip

# pip install -r $HOME/.dotfiles/requirements.txt

echo "all ready pyenv."
