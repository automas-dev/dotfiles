#!/bin/bash

# Exit if any command fails
set -e

# Echo commands before execution
#set -x

# colorize output, see https://stackoverflow.com/questions/5947742
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo_red() { echo -e "${RED}$*${NC}"; }
echo_green() { echo -e "${GREEN}$*${NC}"; }
echo_yellow() { echo -e "${YELLOW}$*${NC}"; }
echo_white() { echo -e "${WHITE}$*${NC}"; }

echo_white "Git Submodule Update"

git submodule update --init --recursive

is_distro() {
    grep "$1" </proc/version
}

echo_white "Install ansible"

if is_distro Ubuntu; then
    echo_green Detected Ubuntu Distro
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install ansible
elif is_distro archlinux; then
    echo_green Detected Archlinux Distro
    sudo pacman -Syu
    sudo pacman -S --noconfirm ansible
else
    echo_red "Unknown linux distro '$(cat /proc/version)'"
    exit 1
fi

echo -e """
================================================================================
                                 Setup Complete                                 
================================================================================

But, this is only this repo. To setup the system, use these steps.

==========
${WHITE}Install${NC}
----------
All

ansible-playbook install.yaml

This will also install all of the following, which can be installed separately.

----------
System Base

ansible-playbook install_system.yaml

----------
User Config

ansible-playbook install_user.yaml

----------
You can also choose to only install dotfiles, and no other user configurations.

gio trash ~/.bashrc
./install_dotfiles.sh

----------
Desktop Apps

ansible-playbook install_desktop.yaml

==========
${WHITE}Add SSH key to Github${NC}

xclip -sel clipboard <~/.ssh/id_rsa.pub

Add ssh key to Github using https://github.com/settinsg/keys

---------
Update remote to use ssh

git remote set-url origin git@github.com:twh2898/dotfiles.git
git pull
"""
