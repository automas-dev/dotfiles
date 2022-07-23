#!/bin/bash

set -e

git submodule update --init --recursive

is_distro() {
    grep "$1" </proc/version
}

if is_distro Ubuntu; then
    sudo apt-get update
    sudo apt-get -y upgrade
elif is_distro Arch; then
    sudo pacman -Syu
else
    echo "Unknown linux distro"
    exit 1
fi

sudo apt-get -y install ansible

ansible-playbook install.yaml
gio trash ~/.bashrc
./install

xclip -sel clipboard <~/.ssh/id_rsa.pub
echo "SSH Key copied to clipboard"
read -p "Press return after adding your SSH key to https://github.com/settinsg/keys"

git remote set-url origin git@github.com:twh2898/dotfiles.git
git pull
