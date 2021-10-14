#!/bin/bash

set -Ceu

echo "Install Docker!"
echo

# 公式の手順でインストールしていく
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo service docker start

if [[ "Hello from Docker!" != $(sudo docker run hello-world | head -n 2 | tail -n 1) ]]; then
    echo "Install failed!!"
    echo
    exit 1
fi

sudo usermod -aG docker shidaru

echo "Installed Docker!!"

echo "Please logout from shell."
echo
