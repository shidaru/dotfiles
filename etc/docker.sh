#!/bin/bash

echo "Ready to Docker!"

sudo apt-get remove docker docker-engine docker.io

sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

sudo curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"

sudo apt-get update

sudo apt-get -y install docker-ce

USERNAME=$(whoami)
sudo adduser $USERNAME docker

echo "All ready to Docker!!"
