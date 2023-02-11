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
    local disk
    disk="$1"

    echo "Partitioning $disk"

    # Clear the disk
    sgdisk -Z "$disk"

    sgdisk -n 0:0:+512M -t 0:ef00 -c 0:"boot" "$disk"
    sgdisk -n 0:0:0 -t 0:8300 -c 0:"linux" "$disk"

    # inform the OS of partition table changes
    partprobe "$disk"

    sgdisk -p "$disk"
}

make_fs() {
    local boot root
    boot="$1"
    root="$2"
    mkfs.fat -F32 "$boot"
    mkfs.ext4 "$root"
}

setup_crypt() {
    local part
    part="$1"
    cryptsetup luksFormat --type luks1 "$part"
    cryptsetup open "$part" cryptlvm
}

setup_lvm() {
    local part lvname
    part="$1"
    lvname="$2"
    pvcreate /dev/mapper/cryptlvm
    vgcreate "$lvname" /dev/mapper/cryptlvm
}

create_swap() {
    local lvname size
    lvname="$1"
    size="$2"
    lvcreate -L "$size" "$lvname" -n swap
    mkswap "/dev/$lvname/swap"
}

create_root() {
    local lvname
    lvname="$1"
    lvcreate -l 100%FREE "$lvname" -n root
    mkfs.ext4 "/dev/$lvname/root"
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


install_system() {
    local root
    root="$1"
    pacman -Sy --noconfirm --needed archlinux-keyring
    pacstrap "$root" base linux linux-firmware base-devel git vi vim networkmanager sudo lvm2 efibootmgr
    genfstab -U "$root" >> "$root/etc/fstab"
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

setup_system() {
    local root hostname
    root="$1"
    hostname="$2"
    timedatectl set-ntp true
    hwclock --systohc
    arch-chroot "$root" systemctl enable NetworkManager.service
    arch-chroot "$root" ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
    echo "en_US.UTF-8 UTF-8" >> "$root/etc/locale.gen"
    arch-chroot "$root" locale-gen
    echo "LANG=en_US.UTF-8" > "$root/etc/locale.conf"
    echo "$hostname" > "$root/etc/hostname"
    echo "Set the root password"
    arch-chroot "$root" passwd
}

setup_user() {
    local root user
    root="$1"
    user="$2"
    arch-chroot "$root" useradd -m -G "sudo" -s /bin/bash "$user"
    echo "Set the password for thomas"
    arch-chroot "$root" passwd thomas
}

echo Remember to connect to the internet first. You will need to use
echo Ethernet -- plug in the cable
echo Wi-Fi -- connect to the network using iwctl
read -rp "Press enter to continue..."

header "Setup"
test_network
setup_installer
echo Setup complete

header "Disk partition"
echo "You are about to modify $DISK"
do_confirm

backup_disk "$DISK"
part_disk "$DISK"

readarray -t PARTS < <(sudo fdisk -l | grep -e "^$DISK" | awk '{print $1}')
echo "Partitions are ${PARTS[*]}"

if [ ${#PARTS[@]} -ne 2 ]; then
    echo "Unexpected partitions ${PARTS[*]}"
    echo "Need 2"
    exit 2
fi

boot="${PARTS[0]}"
root="${PARTS[1]}"
make_fs "$boot" "$root"

header "Setup encryption"
setup_crypt "$root"

header "Setup lvm"
free -h
read -rp "Enter the swap volume size(eg. 2*mem): " SWAP

setup_lvm "$root" vg
create_swap vg "$SWAP"
create_root vg
mount_lvm vg "$boot" /mnt

header "Install system"
read -rp "Enter a hostname: " HOSTNAME
install_system /mnt
setup_boot "$DISK" "$root" /mnt
setup_system /mnt "$HOSTNAME"
setup_user /mnt thomas

