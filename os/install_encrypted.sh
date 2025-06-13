#!/bin/bash

# Exit if any command fails
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <disk>"
    exit 1
fi

DISK="$1"

source com.sh

crypt::format_part() {
    local part
    part="$1"
    cryptsetup luksFormat --type luks1 "$part"
    cryptsetup open "$part" cryptlvm
}
# usage: crypt::format_part <root_part>

lvm::create_mapper() {
    local part lvname
    part="$1"
    lvname="$2"
    pvcreate /dev/mapper/cryptlvm
    vgcreate "$lvname" /dev/mapper/cryptlvm
}
# usage: lvm::create_mapper <root_part> <lvname>

lvm::create_swap_vol() {
    local lvname size
    lvname="$1"
    size="$2"
    lvcreate -L "$size" "$lvname" -n swap
    mkswap "/dev/$lvname/swap"
}
# usage: lvm::create_swap_vol <lvname> <swap_size>

lvm::create_root_vol() {
    local lvname
    lvname="$1"
    lvcreate -l 100%FREE "$lvname" -n root
    mkfs.ext4 "/dev/$lvname/root"
}
# usage: lvm::create_root_vol <lvname>

lvm::mount() {
    local lvname boot path
    lvname="$1"
    boot="$2"
    path="$3"
    disk::mount "$path" "$boot" "/dev/$lvname/root" "/dev/$lvname/swap"
}
# usage: lvm::mount <lvname> <boot_part> <mount_path>

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
    arch-chroot "$mnt" efibootmgr \
        --create \
        --disk "$disk" \
        --part 1 \
        --label "Arch Linux" \
        --loader /vmlinuz-linux \
        --unicode "cryptdevice=UUID=$PART_UUID:cryptlvm root=/dev/vg/root resume=/dev/vg/swap rw initrd=\\initramfs-linux.img"
}

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
# note skipping swap parition size here since it's part of lvm instead
disk::partition "$DISK"

readarray -t PARTS < <(sudo fdisk -l | grep -e "^$DISK" | awk '{print $1}')
echo "Partitions are ${PARTS[*]}"

if [ ${#PARTS[@]} -ne 2 ]; then
    echo "Unexpected partitions ${PARTS[*]}"
    echo "Need 2"
    exit 2
fi

boot="${PARTS[0]}"
root="${PARTS[1]}"
disk::make_fs "$boot" "$root"

header "Setup encryption"
crypt::format_part "$root"

header "Setup lvm"
free -h
read -rp "Enter the swap volume size(eg. 2*mem): " SWAP

lvm::create_mapper"$root" vg
lvm::create_swap_vol vg "$SWAP"
lvm::create_root_vol vg
lvm::mount vg "$boot" /mnt

header "Install system"
read -rp "Enter a hostname: " HOSTNAME
USERNAME=$(read_with_default "Username" "thomas")
system::install_os /mnt
setup_boot "$DISK" "$root" /mnt
system::configure_os /mnt "$HOSTNAME"
system::configure_user /mnt "$USERNAME"
