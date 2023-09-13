#!/bin/bash

# Exit if any command fails
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <disk>"
    exit 1
fi

DISK="$1"

header() {
    echo "--------------------"
    echo -e "\033[1m$*\033[0m"
    echo "--------------------"
    echo
}

do_confirm() {
    local CONFIRM
    echo -n "ARE YOU SURE YOU WANT TO CONTINUE (yN): "
    read -r CONFIRM
    case "$CONFIRM" in
        Y|y) echo Yes;;
        *) exit 0;;
    esac
}

open_crypt() {
    local part
    part="$1"
    cryptsetup open "$part" cryptlvm
}

mount_lvm() {
    local lvname boot path
    lvname="$1"
    boot="$2"
    path="$3"
    mount --mkdir "/dev/$lvname/root" "$path"
    mount --mkdir "$boot" "$path/boot"
    swapon "/dev/$lvname/swap"
}

setup_boot() {
    local disk part mnt
    disk="$1"
    part="$2"
    mnt="$3"
    echo "HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)" >> "$mnt/etc/mkinitcpio.conf"
    echo "MODULES=(ext4)" >> "$mnt/etc/mkinitcpio.conf"
    arch-chroot "$mnt" mkinitcpio -p linux
    PART_UUID="$(blkid -o value -s UUID "$part")"
    echo PART_UUID is $PART_UUID
    arch-chroot "$mnt" efibootmgr --create --disk "$disk" --part 1 --label "Arch Linux" --loader /vmlinuz-linux --unicode "cryptdevice=UUID=$PART_UUID:cryptlvm root=/dev/vg/root resume=/dev/vg/swap rw initrd=\\initramfs-linux.img"
}

echo Remember to connect to the internet first. You will need to use
echo Ethernet -- plug in the cable
echo Wi-Fi -- connect to the network using iwctl
echo Remember to update /etc/pacman.conf to enable parallel downloads
read -rp "Press enter to continue..."

header "Setup"
test_network
echo Setup complete

header "Disk partition"
echo "You are about to modify $DISK"
do_confirm

readarray -t PARTS < <(sudo fdisk -l | grep -e "^$DISK" | awk '{print $1}')
echo "Partitions are ${PARTS[*]}"

if [ ${#PARTS[@]} -ne 2 ]; then
    echo "Unexpected partitions ${PARTS[*]}"
    echo "Need 2"
    exit 2
fi

boot="${PARTS[0]}"
root="${PARTS[1]}"
open_crypt "$root"
mount_lvm vg "$boot" /mnt

header "Install system"
setup_boot "$DISK" "$root" /mnt

