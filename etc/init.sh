#!/bin/bash

env=$(uname -a)

if [[ $env =~ "Microsoft" ]]; then
    eval "./etc/wls.sh"
elif [[ $env =~ "Linux" ]]; then
    eval "./etc/linux.sh"
fi
