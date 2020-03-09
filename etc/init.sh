#!/bin/bash

set -Ceuo pipefail
export LC_ALL=C
export LANG=C

# このスクリプト自身のディレクトリに移動する
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

env=$(uname -a)
echo "Environment is ${env}"
echo ""

if [[ $env =~ "Microsoft" ]]; then
    eval "./wsl.sh"
elif [[ $env =~ "Linux" ]]; then
    eval "./linux.sh"
fi
