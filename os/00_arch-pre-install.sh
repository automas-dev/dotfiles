#!/bin/bash

echo Remember to connect to the internet first. You will need to use
echo Ethernet -- plug in the cable
echo Wi-Fi -- connect to the network using iwctl

if ping -c 1 -W 1 archlinux.og > /dev/null 2>&1; then
    echo "Can't ping archlinux.org"
    echo "Check your internet connection"
    exit 2
fi

pacman -Sy --noconfirm --needed archlinux-keyring gptfdisk

timedatectl set-ntp true

echo Setup complete, you may now install the system

