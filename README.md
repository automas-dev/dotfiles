# Dotfiles

My linux configuration files + some helpful scripts.

## Usage

While this repo can be cloned anywhere, some features depend on it being
`~/dotfiles`.

```sh
git clone https://github.com/twh2898/dotfiles.git ~/dotfiles
cd ~/dotfiles
./post-clone.sh
```

### Install Dotfiles

Create sym links for dotfiles and config files.

```sh
./install_dotfiles.sh
```

### Install Everything

This includes

- Base packages
- Desktop environments
- User configuration

```sh
./install_user.yaml
```

### Partial Install

#### Base Packages

This includes

- Base packages

```sh
./install_base.yaml
```

#### Desktop

This includes

- Base packages
- Desktop environments

```sh
./install_desktop.yaml
```

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
- htop through pacman
- configure pacman
  - color
  - verbose package list
- flatpak (only ones that aren't system packages?)
  - Spotify
  - ~~Gimp~~
  - ~~Inkscape~~
  - ~~vlc~~
  - ~~kdenlive~~
  - ~~darktable~~
- packages
  - shellcheck
- backup_client restic password
- Move neovim config files to role
- Move dotfiles to role
  - most to user config?
- Git role
  - install
  - git config
- Wallpaper in desktop config
- Use handlers in roles (eg. to restart service if changes to config)
- Fail when clean tag var is not defined for backup_server

### Tom Lan

- mdadm for raid

## Errors

User desktop keyboard interval fails when desktop is installed at same time.
