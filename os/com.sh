#!/bin/bash

if [ -n "${COM_IMPORT}" ]; then
    echo "[WARNING] Tried to source alredy sourced file $0, skipping"
    return 
fi
COM_IMPORT=1

FG_BOLD="\033[1m"
FG_RED="\033[31m"
FG_YELLOW="\033[33m"
FG_GREEN="\033[32m"
FG_BLUE="\033[34m"
FG_WHITE="\033[37m"
RESET="\033[0m"

# ----------------
# HELPER FUNCTIONS
# ----------------

header() {
    local msg
    msg="$*"
    echo "--------------------"
    echo -e "${FG_BOLD}${FG_WHITE}${msg}${RESET}"
    echo "--------------------"
    echo
}
# usage: header <message>

test_network() {
    if ping -c 1 -W 1 archlinux.og > /dev/null 2>&1; then
        echo "Can't ping archlinux.org"
        echo "Check your internet connection"
        exit 2
    fi
}
# usage: test_network

setup_installer() {
    pacman -Sy --noconfirm --needed archlinux-keyring gptfdisk
    timedatectl set-ntp true
}
# usage: setup_installer

do_confirm() {
    local CONFIRM
    echo -n "ARE YOU SURE YOU WANT TO CONTINUE (yN): "
    read -r CONFIRM
    case "$CONFIRM" in
        Y|y) echo Yes;;
        *) exit 0;;
    esac
}
# usage: do_confirm

read_with_default() {
    local name default value
    name="$0"
    default="$1"
    echo -n "${name} [${default}]: "
    read -r value
    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}
# usage: read_with_default <name> <default>

# ---------------
# DISK OPERATIONS
# ---------------

disk::backup() {
    local disk backup
    disk="$1"
    backup="$(date -Iseconds).part.bak"
    echo "Backing up $disk to $backup"
    sgdisk -p "$disk" > "$backup"
    echo Backup complete
}
# usage: disk::backup_disk <disk_path>

disk::make_fs() {
    local boot root swap
    boot="$1"
    root="$2"
    swap="$3"
    mkfs.fat -F32 "$boot"
    mkfs.ext4 "$root"
    if [ -n "$swap" ]; then
        mkswap "$swap"
    fi
}
# usage: disk::make_fs <boot_part> <root_part> [swap_part]

disk::partition() {
    local disk swap_size
    disk="$1"
    swap_size="$2"

    echo "Partitioning $disk"
    if [ -n "$swap_size" ]; then
        echo "Swap partition will be created"
    fi

    # Clear the disk
    sgdisk -Z "$disk"

    sgdisk -n 0:0:+512M -t 0:ef00 -c 0:"boot" "$disk"
    if [ -z "$swap_size" ]; then
        sgdisk -n 0:0:0 -t 0:8300 -c 0:"linux" "$disk"
    else
        sgdisk -n 0:0:"-${swap_size}" -t 0:8300 -c 0:"linux" "$disk"
        sgdisk -n 0:0:0 -t 0:8200 -c 0:"swap" "$disk"
    fi

    # inform the OS of partition table changes
    partprobe "$disk"

    sgdisk -p "$disk"
}
# usage: disk::partition <disk> [swap_size]

disk::mount() {
    local path boot root swap
    path="$1"
    boot="$2"
    root="$3"
    swap="$4"
    mount --mkdir "$root" "$path"
    mount --mkdir "$boot" "$path/boot"
    if [ -n "$swap" ]; then
        swapon "$swap"
    fi
}
# usage: disk::mount <mount_path> <boot_part> <root_part> [swap_part]

# --------------
# SYSTEM INSTALL
# --------------

system::install_os() {
    local root_mnt
    root_mnt="$1"
    pacman -Sy --noconfirm --needed archlinux-keyring
    pacstrap "$root_mnt" base linux linux-firmware base-devel git vi vim networkmanager sudo lvm2 efibootmgr
    genfstab -U "$root_mnt" >> "$root_mnt/etc/fstab"
}
# usage: system::install_os <root_mount>

system::configure_os() {
    local root_mnt hostname
    root_mnt="$1"
    hostname="$2"
    timedatectl set-ntp true
    hwclock --systohc
    echo "en_US.UTF-8 UTF-8" >> "$root_mnt/etc/locale.gen"
    echo "LANG=en_US.UTF-8" > "$root_mnt/etc/locale.conf"
    echo "$hostname" > "$root_mnt/etc/hostname"
    arch-chroot "$root_mnt" bash <<EOF
systemctl enable NetworkManager.service
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
locale-gen
EOF
    echo "Set the root password"
    arch-chroot "$root_mnt" passwd
}
# usage: system::configure_os <root_mount> <hostname>

system::configure_user() {
    local root_mnt user
    root_mnt="$1"
    user="$2"
    arch-chroot "$root_mnt" useradd -m -G "wheel" -s /bin/bash "$user"
    echo "Set the password for thomas"
    arch-chroot "$root_mnt" passwd thomas
}
# usage: system::configure_user <root_mount> <username>
