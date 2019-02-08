#!/bin/bash

# 自動import挿入
go get golang.org/x/tools/cmd/goimports
# 関数定義等の参照パッケージ
go get github.com/rogpeppe/godef
# 補完パッケージ
go get -u github.com/nsf/gocode
# flycheckでシンタックスエラーを検知
go get github.com/golang/lint/golint
# flycheckでシンタックスエラーを検知
go get github.com/kisielk/errcheck
