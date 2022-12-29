#!/bin/bash

# Exit if any command fails
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <disk>"
    exit 1
fi

DISK="$1"

do_confirm() {
    local CONFIRM
    echo -n "ARE YOU SURE YOU WANT TO CONTINUE (yN): "
    read CONFIRM
    case "$CONFIRM" in
        Y|y) echo Yes;;
        *) exit 0;;
    esac
}

do_backup() {
    local BACKUP
    BACKUP="$(date -Iseconds).part.bak"
    echo Backing up $DISk to $BACKUP
    sgdisk -p "$DISK" > "$BACKUP"
    echo Backup complete
}

do_partition() {
    echo Writing partition

    # Clear the disk
    sgdisk -Z "$DISK"

    sgdisk -n 0:0:+1M -t 0:ef02 -c 0:"bios_boot" "$DISK"
    sgdisk -n 0:0:+550M -t 0:ef00 -c 0:"efi_system" "$DISK"
    sgdisk -n 0:0:0 -t 0:8300 -c 0:"linux" "$DISK"

    sgdisk -p "$DISK"

    # inform the OS of partition table changes
    partprobe "$DISK"
    fdisk -l "$DISK"
}

echo YOU ARE ABOUT TO MODIFY $DISK
echo ALL CHANGES ARE PERMENTANT
echo YOU WILL NOT BE ABLE TO RECOVER THE CURRENT STATE
echo

do_confirm

do_backup

do_confirm

do_partition

echo Time to format these partitions
echo BIOS and EFI partition: mkfs.fat -F32

