#!/bin/bash


scriptDir="./etc"

function install() {
  git pull origin master
  eval "$scriptDir/init.sh"
  eval "$scriptDir/deploy.sh"
}

action=$1
if [[ $action == "" ]]; then
  echo "init    => Initialize environment settings."
  echo "deploy  => Create symlinks to home directory."
  echo "update  => Fetch all changes from remote repo."
  echo "install => Run update, deploy, init."

elif [[ $action == "init" ]]; then
  echo "Install libraries."
  eval "$scriptDir/init.sh"

elif [[ $action == "deploy" ]]; then
  echo "Deploy dotfiles."
  eval "$scriptDir/deploy.sh"

elif [[ $action == "update" ]]; then
  echo "Update repo."
  git pull origin master

elif [[ $action == "install" ]]; then
  echo "Update => Deploy => init"
  install

else
  echo "[ERROR] Undefined option"
fi
