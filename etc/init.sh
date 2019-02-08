#!/bin/bash

env=$(uname -a)

if [[ $env =~ "Microsoft" ]]; then
    eval "./wls.sh"
elif [[ $env =~ "Linux" ]]; then
    eval "./linux.sh"
fi
