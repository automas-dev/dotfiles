#!/bin/bash

# Exit if any command fails
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <disk>"
    exit 1
fi

PARTITION="$1"

do_confirm() {
    local CONFIRM
    echo -n "ARE YOU SURE YOU WANT TO CONTINUE (yN): "
    read CONFIRM
    case "$CONFIRM" in
        Y|y) echo Yes;;
        *) exit 0;;
    esac
}

read_swap() {
    free -h
    echo -n "Enter swap size: "
    read SWAP_SIZE
}

setup_vg() {
    cryptsetup luksFormat --type luks1 --use-random -S 1 -s 512 -h sha512 -i 5000 "$PARTITION"
    cryptsetup open "$PARTITION" cryptlvm
    pvcreate /dev/mapper/cryptlvm
    vgcreate vg /dev/mapper/cryptlvm
}

setup_lv() {
    lvcreate -L "$SWAP_SIZE" vg -n swap
    lvcreate -l 100%FREE vg -n root
}

do_format() {
    mkfs.ext4 /dev/vg/root
    mkswap /dev/vg/swap
}

do_mount() {
    mount /dev/vg/root /mnt
    swapon /dev/vg/swap
}

echo YOU ARE ABOUT TO MODIFY $PARTITION
echo

do_confirm

read_swap

setup_vg

setup_lv

do_format

do_mount

echo Done

echo "Remember to mount the second partion (efi) at /mnt/efi"

