#!/bin/bash

echo "ready to pyenv."
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

sudo apt-get install -y gcc make libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev

pyenv install 3.7.0

pyenv global 3.7.0

pip install --upgrade pip

pip install -r $HOME/.dotfiles/requirements.txt

echo "all ready pyenv."
