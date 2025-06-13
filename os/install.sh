#!/bin/bash

# Exit if any command fails
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <disk>"
    exit 1
fi

DISK="$1"

source com.sh

setup_boot() {
    local mnt disk root_part swap_part
    mnt="$1"
    disk="$2"
    root_part="$3"
    swap_part="$4"
    arch-chroot "$mnt" mkinitcpio -p linux
    ROOT_PART_UUID="$(blkid -o value -s UUID "$root_part")"
    echo "ROOT_PART_UUID is $ROOT_PART_UUID"
    if [ -n "$swap_part" ]; then
        SWAP_PART_UUID="$(blkid -o value -s UUID "$swap_part")"
        echo "SWAP_PART_UUID is $SWAP_PART_UUID"
        UNICODE="root=${ROOT_PART_UUID} resume=${SWAP_PART_UUID} rw initrd=\\initramfs-linux.img"
    else
        UNICODE="root=${ROOT_PART_UUID} rw initrd=\\initramfs-linux.img"
    fi
    arch-chroot "$mnt" efibootmgr \
        --create \
        --disk "$disk" \
        --part 1 \
        --label "Arch Linux" \
        --loader /vmlinuz-linux \
        --unicode "$UNICODE"
}
# usage: setup_boot <mount_path> <disk_path> <root_part> [swap_part]

echo Remember to connect to the internet first. You will need to use
echo Ethernet -- plug in the cable
echo Wi-Fi -- connect to the network using iwctl
echo Remember to update /etc/pacman.conf to enable parallel downloads
read -rp "Press enter to continue..."

header "Setup"
test_network
setup_installer
echo Setup complete

header "Disk partition"
echo "You are about to modify $DISK"
do_confirm

disk::backup "$DISK"
free -h
read -rp "Enter the swap volume size(eg. 2*mem): " SWAP
disk::partition "$DISK" "$SWAP"

readarray -t PARTS < <(sudo fdisk -l | grep -e "^$DISK" | awk '{print $1}')
echo "Partitions are ${PARTS[*]}"

if [ ${#PARTS[@]} -ne 3 ]; then
    echo "Unexpected partitions ${PARTS[*]}"
    echo "Need 3"
    exit 2
fi

boot="${PARTS[0]}"
root="${PARTS[1]}"
swap="${PARTS[2]}"
disk::make_fs "$boot" "$root" "$swap"
disk::mount /mnt "$boot" "$root" "$swap"

header "Install system"
read -rp "Enter a hostname: " HOSTNAME
USERNAME=$(read_with_default "Username" "thomas")
system::install_os /mnt
setup_boot "$DISK" "$root" /mnt
system::configure_os /mnt "$HOSTNAME"
system::configure_user /mnt "$USERNAME"
