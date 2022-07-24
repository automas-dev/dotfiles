#!/bin/bash

# Exit if any command fails
set -e

# Echo commands before execution
#set -x

# colorize output, see https://stackoverflow.com/questions/5947742
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_red() { echo -e "${RED}$*${NC}"; }
echo_green() { echo -e "${GREEN}$*${NC}"; }
echo_yellow() { echo -e "${YELLOW}$*${NC}"; }

git submodule update --init --recursive

is_distro() {
    grep "$1" </proc/version
}

if is_distro Ubuntu; then
    echo_green Detected Ubuntu Distro
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install ansible
elif is_distro Archlinux; then
    echo_green Detected Archlinux Distro
    sudo pacman -Syu
    sudo pacman -Sy ansible
else
    echo_red "Unknown linux distro"
    exit 1
fi

ansible-playbook install.yaml

while true; do
    read -p "Do you wish to install dotfiles [yn]? " yn
    case $yn in
        [Yy]* ) gio trash ~/.bashrc; ./install_dotfiles.sh; break;;
        [Nn]* ) break;;
        * ) echo_yellow "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to update your SSH key in Github [yn]? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo_yellow "Please answer yes or no.";;
    esac
done

xclip -sel clipboard <~/.ssh/id_rsa.pub
echo "SSH Key copied to clipboard"
read -rp "Press return after adding your SSH key to https://github.com/settinsg/keys"

git remote set-url origin git@github.com:twh2898/dotfiles.git
git pull
