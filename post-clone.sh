#!/bin/bash

set -e

git submodule update --init --recursive

sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get -y install ansible

ansible-playbook install.yaml
./install

xclip -sel clipboard < ~/.ssh/id_rsa.pub
echo "SSH Key copied to clipboard"
read -p "Press return after adding your SSH key to https://github.com/settinsg/keys"

git remote set-url origin git@github.com:twh2898/dotfiles.git
git pull
