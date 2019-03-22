#!/bin/bash

function remove_doublequotation() {
    # 文字列のダブルクォートを外す
    # 入力は標準入力（パイプで渡す）
    sed "s/\"//g"
}

function create_curlrc() {
    #認証プロキシであればユーザ、パスワードを含んだプロキシ情報を作成する。
    cat << EOS > ~/.curlrc
proxy=$1
EOS

    # if [ $1 -eq 1 ]; then

# 	cat << EOS > ~/.curlrc
# proxy-user=${PROXY_USER}:${PROXY_PASS}
# proxy=${PROTOCOL}://${PROXY_HOST}:${PROXY_PORT}
# EOS

#     elif [ $1 -eq 0 ]; then

# 	cat << EOS > ~/.curlrc
# proxy=${PROTOCOL}://${PROXY_HOST}:${PROXY_PORT}
# EOS

#     fi
}

function create_wgetrc() {
    #認証プロキシであればユーザ、パスワードを含んだプロキシ情報を作成する。
    cat << EOS > ~/.wgetrc
http_proxy=$1
EOS

#     if [ $1 -eq 1 ]; then

# 	cat << EOS > ~/.wgetrc
# http_proxy=${PROTOCOL}://${PROXY_HOST}:${PROXY_PORT}
# proxy_user=${PROXY_USER}
# proxy_password=${PROXY_PASS}
# EOS

#     elif [ $1 -eq 0 ]; then

# 	cat << EOS > ~/.wgetrc
# http_proxy=${PROTOCOL}://${PROXY_HOST}:${PROXY_PORT}
# EOS

#     fi
}

function export_url() {
    echo $1
    export http_proxy=$1
    export HTTP_PROXY=$1
    export https_proxy=$1
    export HTTPS_PROXY=$1
    export ftp_proxy=$1
    export FTP_PROXY=$1
    export PIP_INDEX_URL=http://pypi.python.org/simple/
    export PIP_TRUSTED_HOST=pypi.python.org
}

function set_proxy() {
    if [ ! -e $HOME/.proxy.txt ]; then
	echo "Proxy infomation file is not."
	exit 0
    fi

    while read row; do
	export_url $row
	create_curlrc $row
	create_wgetrc $row
    done < $HOME/.proxy.txt

    #ユーザ名、パスワードが設定されていれば認証プロキシとして処理する。
    # if [[ $PROXY_USER != "" && $PROXY_PASS != "" ]]; then
    # 	PROXY=$PROTOCOL://$PROXY_USER:$PROXY_PASS@$PROXY_HOST:$PROXY_PORT
    # 	create_curlrc 1
    # 	create_wgetrc 1
    # else
    # 	PROXY=$PROTOCOL://$PROXY_HOST:$PROXY_PORT
    # 	create_curlrc 0
    # 	create_wgetrc 0
    # fi

}

function unset_proxy() {
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset ftp_proxy
    unset FTP_PROXY
    unset PIP_INDEX_URL
    unset PIP_TRUSTED_HOST
    rm -f ~/.curlrc
    rm -f ~/.wgetrc
}

if [ "$1" = "s" ]; then
    echo "SET PROXY"
    set_proxy IS_AUTH
elif [ "$1" = "u" ]; then
    echo "UNSET PROXY"
    unset_proxy
else
    echo "s or u"
fi
