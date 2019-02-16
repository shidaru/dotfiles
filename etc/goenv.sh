#!/bin/bash

echo "ready to goenv."

git clone https://github.com/syndbg/goenv.git $HOME/.goenv

goenv install 1.11.5

goenv gloval 1.11.5

echo "all ready goenv."
