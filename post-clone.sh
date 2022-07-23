#!/bin/bash

set -e

git submodule update --init --recursive

is_distro() {
    grep "$1" </proc/version
}

if is_distro Ubuntu; then
    echo Detected Ubuntu Distro
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install ansible
elif is_distro Archlinux; then
    echo Detected Archlinux Distro
    sudo pacman -Syu
    sudo pacman -Sy ansible
else
    echo "Unknown linux distro"
    exit 1
fi

# ansible-playbook install.yaml

while true; do
    read -p "Do you wish to install dotfiles? " yn
    case $yn in
        [Yy]* ) gio trash ~/.bashrc; ./install; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to update your SSH key in Github? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

xclip -sel clipboard <~/.ssh/id_rsa.pub
echo "SSH Key copied to clipboard"
read -rp "Press return after adding your SSH key to https://github.com/settinsg/keys"

git remote set-url origin git@github.com:twh2898/dotfiles.git
git pull
