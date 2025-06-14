# Dotfiles

My linux configuration files + some helpful scripts.

## Usage

While this repo can be cloned anywhere, some features depend on it being
`~/dotfiles`.

```sh
git clone https://github.com/automas-dev/dotfiles.git
cd dotfiles
./post-clone.sh
```

### Install Everything

This includes

- Base packages
- System packages
- Desktop environments
- User configuration

```sh
./install.yaml --ask-become-pass -u $USER
```

**NOTE:** If you want to install packages but skip user configuration, append
`--skip-tags user_config` to the install command.

Available tags, to skip or keep, are `base`, `system`, `desktop`, `user_config`,
and `enable_backups` (skip by default). These can be used inclusive `--tags` or
exclusive `--skip-tags`

## Server Install

This section is specific to `tom-lan` but could be applicable to any server
in the hosts file.

```sh
./install_server.yaml --ask-become-pass -u thomas
```

## Using Vaults

Vaults can be included with `-e@vaults/vault_name.yml --ask-vault-pass`

### Post Install

#### Enable Clean Backups

Replace `hostname` with the hostname of the backup.

```sh
systemctl --user enable clean_backup@hostname.time
```

## OS Install

The `./os` directory includes scripts for installing the base Archlinux OS.
This can be used directly with the Archlinux setup media. After booting to
your usb drive, connect to the interned and run the following commands. Follow
all prompts and pay attention, they will appear throughout the install process,
potentially with large gaps of time between.

```sh
pacman -Sy archlinux-keyring git
git clone https://github.com/automas-dev/dotfiles.git
cd dotfiles/os
./install_encrypted.sh /dev/sda
```

To install the os without encrypting the hard drive, run `install.sh` in place of
`install_encrypted.sh`

## TO FIX

- Yay fails to build with makepkg
  - Fails if run as root, prompts for sudo password and times out

## TODO

- Install options
  - Select System
    - Server
    - Ubuntu
    - Arch
    - Laptop?
  - Select Profile
    - Home
    - World
    - Work
    - Other?
  - Select Window Manager
    - plasma
    - cinnamon
    - i3?
- Settings
  - Plasma
    - Keyboard / Mouse
    - Show battery percentage
    - Power mode
      - When to sleep / dim
    - Default Application
      - Browser
      - Terminal
  - Blender
    - Key bindings
    - Plugins
      - Easy HDRI
      - Hard ops
      - Box cutter
      - Lilly
      - Lux core
- Terminal for i3
- backup_client restic password
- Move dotfiles to role
  - most to user config?
- Wallpaper in desktop config
- Use handlers in roles (eg. to restart service if changes to config)

### Tom Lan

- mdadm for raid

## Errors

User desktop keyboard interval fails when desktop is installed at same time.
