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

usage() {
    echo "Usage: post-clone.sh [options]"
    echo "Options:"
    echo "    -h | --help       show this help message"
    echo "    -d | --dry-run    echo action instead of executing them"
    echo "    -v | --verbose    echo more information"
    echo ""
    echo "    --skip-origin     skip updating the origin url"
    echo "    --skip-submodule  skip submodule update"
    echo "    --skip-updates    skip installing updates"
    echo "    --skip-dotfiles   skip installing dotfiles"
    echo "    --skip-copy-key   skip copying ssh key to clipboard"
}

for arg in "$@"; do
    case "$arg" in
        -h|--help) usage; exit 0;;
        -d|--dry-run) DRY_RUN=true;;
        -v|--verbose) VERBOSE=true;;
        --skip-origin) SKIP_ORIGIN=true;;
        --skip-submodule) SKIP_SUBMODULE=true;;
        --skip-updates) SKIP_UPDATES=true;;
        --skip-dotfiles) SKIP_DOTFILES=true;;
        --skip-copy-key) SKIP_COPY_KEY=true;;
    esac
done

run() {
    if [ $DRY_RUN ]; then
        echo "$ $*"
    else
        eval "$*"
    fi
}

if [ $DRY_RUN ]; then
    echo_yellow "This is a dry run, actions will be echoed instead of performed"
fi

if [ ! $SKIP_SUBMODULE ]; then
    echo "Updating git submodules"
    run git submodule update --init --recursive
fi

is_distro() {
    grep -i "$1" </proc/version >/dev/null
}

if [ ! $SKIP_UPDATES ]; then
    echo "Updateing base system"
    if is_distro ubuntu; then
        echo_green "Detected Ubuntu Distro"
        run sudo apt-get update
        run sudo apt-get -y upgrade
        run sudo apt-get -y install ansible
    elif is_distro archlinux; then
        echo_green "Detected Archlinux Distro"
        run sudo pacman -Syu
        run sudo pacman -Sy ansible
    else
        echo_red "Unknown linux distro"
        echo "Exiting!"
        exit 1
    fi
fi

run ansible-playbook install.yaml

if [ ! $SKIP_DOTFILES ]; then
    echo "Installing dotfiles"
    run gio trash ~/.bashrc
    run ./install_dotfiles.sh
fi

if [ ! $SKIP_COPY_KEY ]; then
    echo "Copying ~/.ssh/id_rsa.pub to clipboard"
    run "xclip -sel clipboard <~/.ssh/id_rsa"
    [ ! $DRY_RUN ] && echo "SSH Key copied to clipboard"
    [ ! $DRY_RUN ] && read -rp "Press return after adding your SSH key to https://github.com/settinsg/keys"
fi

if [ ! $SKIP_ORIGIN ]; then
    run git remote set-url origin git@github.com:twh2898/dotfiles.git
    run git pull
fi
