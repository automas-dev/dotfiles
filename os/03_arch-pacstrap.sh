#!/bin/bash

# Idea: Prompt for boot type (GPT) and username and password

# TODO: Take drive path and partition it for GPT
#  512M for boot
#  last 2 * ram for swap

pacman -Sy --noconfirm --needed archlinux-keyring

pacstrap /mnt base linux linux-firmware base-devel git vi vim networkmanager sudo

arch-chroot /mnt systemctl enable NetworkManager.service

genfstab -U /mnt >> /mnt/etc/fstab

timedatectl set-ntp true

hwclock --systohc

# TODO: arch-chroot /mnt ln -sf time zone

echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen

arch-chroot /mnt locale-gen

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo "Remember to set the hostname in /etc/hostname"
echo "Remember to change the root password"
echo "Remember to install a boot loader"

# TODO: install bootloader for GPT

echo "Remember to add user"

# TODO: install yay?
# TODO: git config
