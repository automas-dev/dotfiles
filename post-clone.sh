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
    grep -i "$1" </proc/version >/dev/null
}

echo "Updating base system"
if is_distro ubuntu; then
    echo_green "Detected Ubuntu Distro"
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install ansible
elif is_distro archlinux; then
    echo_green "Detected Archlinux Distro"
    sudo pacman -Syu --noconfirm
    sudo pacman -Sy --noconfirm ansible
else
    echo_red "Unknown linux distro"
    echo "Exiting!"
    exit 1
fi
