#!/bin/bash
# 自動的には実行されないので、最新バージョンを確認してから適宜実行すること

set -Ceu

echo "Install docker-compose"
echo

if [ $# != 1 ]; then
    echo "Error: コマンドライン引数で、docker-compose のバージョンを指定してください"
    echo
    exit 1
fi

VERSION="$1"
echo "docker-compose version is ${VERSION}"
echo

# 公式の手順でインストールしていく
curl=$(cat <<EOS
sudo
 curl
 -L
 https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)
 -o
/usr/local/bin/docker-compose
EOS
)
eval ${curl}

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "Installed docker-compose!"
echo
