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

test_network() {
    if ping -c 1 -W 1 archlinux.og > /dev/null 2>&1; then
        echo "Can't ping archlinux.org"
        echo "Check your internet connection"
        exit 2
    fi
}

setup_installer() {
    pacman -Sy --noconfirm --needed archlinux-keyring gptfdisk
    timedatectl set-ntp true
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

backup_disk() {
    local disk backup
    disk="$1"
    backup="$(date -Iseconds).part.bak"
    echo "Backing up $disk to $backup"
    sgdisk -p "$disk" > "$backup"
    echo Backup complete
}

part_disk() {
    local disk swap
    disk="$1"
    swap="$2"

    echo "Partitioning $disk with swap size $swap"

    # Clear the disk
    sgdisk -Z "$disk"

    sgdisk -n 0:0:+512M -t 0:ef00 -c 0:"boot" "$disk"
    sgdisk -n "0:0:-$swap" -t 0:8300 -c 0:"linux" "$disk"
    sgdisk -n 0:0:0 -t 0:8200 -c 0:"swap" "$disk"

    # inform the OS of partition table changes
    partprobe "$disk"

    sgdisk -p "$disk"
}

make_fs() {
    local boot root swap
    boot="$1"
    root="$2"
    swap="$3"
    mkfs.fat -F32 "$boot"
    mkfs.ext4 "$root"
    mkswap "$swap"
}

mount_fs() {
    local boot root swap path
    boot="$1"
    root="$2"
    swap="$3"
    path="$4"
    mount --mkdir "$root" "$path"
    mount --mkdir "$boot" "$path/boot"
    swapon "$swap"
}

install_system() {
    local root
    root="$1"
    pacman -Sy --noconfirm --needed archlinux-keyring
    pacstrap "$root" base linux linux-firmware base-devel git vi vim networkmanager sudo efibootmgr
    genfstab -U "$root" >> "$root/etc/fstab"
}

setup_boot() {
    local disk root swap mnt
    disk="$1"
    root="$2"
    swap="$3"
    mnt="$4"
    echo "HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)" >> "$mnt/etc/mkinitcpio.conf"
    echo "MODULES=(ext4)" >> "$mnt/etc/mkinitcpio.conf"
    arch-chroot "$mnt" mkinitcpio -p linux
    ROOT_UUID="$(blkid -o value -s UUID "$root")"
    SWAP_UUID="$(blkid -o value -s UUID "$swap")"
    echo ROOT_UUID is $ROOT_UUID
    echo SWAP_UUID is $SWAP_UUID
    arch-chroot "$mnt" efibootmgr --create \
        --disk "$disk" \
        --part 1 \
        --label "Arch Linux" \
        --loader /vmlinuz-linux \
        --unicode "root=UUID=$ROOT_UUID resume=UUID=$SWAP_UUID rw initrd=\\initramfs-linux.img"
}

setup_system() {
    local root hostname
    root="$1"
    hostname="$2"
    timedatectl set-ntp true
    hwclock --systohc
    echo "en_US.UTF-8 UTF-8" >> "$root/etc/locale.gen"
    echo "LANG=en_US.UTF-8" > "$root/etc/locale.conf"
    echo "$hostname" > "$root/etc/hostname"
    arch-chroot "$root" bash <<EOF
systemctl enable NetworkManager.service
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
locale-gen
EOF
    echo "Set the root password"
    arch-chroot "$root" passwd
}

setup_user() {
    local root user
    root="$1"
    user="$2"
    arch-chroot "$root" useradd -m -G "wheel" -s /bin/bash "$user"
    echo "Set the password for $user"
    arch-chroot "$root" passwd "$user"
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

free -h
read -rp "Enter the swap volume size(eg. 2*mem): " SWAP

backup_disk "$DISK"
part_disk "$DISK" "$SWAP"

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
make_fs "$boot" "$root" "$swap"
mount_fs "$boot" "$root" "$swap" /mnt

header "Install system"
read -rp "Enter a hostname: " HOSTNAME
install_system /mnt
setup_boot "$DISK" "$root" "$swap" /mnt
setup_system /mnt "$HOSTNAME"
setup_user /mnt thomas

