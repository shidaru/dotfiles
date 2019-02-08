#!/bin/bash


VERSION=$1

echo "Start install golang."

mkdir ./tmp
cd ./tmp

url=https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz
wget $url

mkdir -p $HOME/local
mkdir -p $HOME/.go
go=go$VERSION.linux-amd64.tar.gz
tar zxf $go
mv go $HOME/local/go

cd ..
rm -rf ./tmp

eval "./goext.sh"

echo "Finished."
