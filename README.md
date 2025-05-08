# Setup

## Install Packages

```sh
pacman -S \
  fwupd \
  cage \
  greetd \
  greetd-gtkgreet \
  sway \
  sway-contrib \
  fuzzel \
  alacritty \
  swaync \
  wl-clipboard \
  swayidle \
  swaylock \
  waybar \
  udiskie \
  wireplumber \
  easyeffects \
  bluez \
  blueman \
  pamixer \
  brightnessctl \
  ripgrep \
  xdg-user-dirs \
  xdg-utils \
  ttf-hack \
  ttf-jetbrains-mono \
  noto-fonts \
  noto-fonts-cjk  \
  noto-fonts-emoji \
  noto-fonts-extra \
  bash-completion \
  git \
  cmake \
  asdf \
  fzf

# Install aur-utils; AUR packges of use:
# ttf-dina-remastered
# bluetooth-autoconnect
# shikane
```

```sh
brew install \
  asdf \
  bash \
  bash-completion@2 \
  font-hack-nerd-font \
  fzf \
  git \
  neovim \
  ripgrep \
  font-hack-nerd-font \
  font-jetbrains-mono-nerd-font \
  flashspace
```

Get Rectangle: https://rectangleapp.com/

## Install Git Repos

Clone and follow default bash+git install, except for bash-it which should be
integrated into .bashrc that will be symlinked below.

- https://github.com/Bash-it/bash-it

## Symlink Stuff

```sh
# All systems
ln -s $HOME/.dot-files/_bashrc $HOME/.bashrc
ln -s $HOME/.dot-files/_gitconfig $HOME/.gitconfig
ln -s $HOME/.dot-files/_gitignore $HOME/.gitignore
ln -s $HOME/.dot-files/_ignore $HOME/.ignore
ln -s $HOME/.dot-files/_inputrc $HOME/.inputrc
ln -s $HOME/.dot-files/_profile $HOME/.profile
ln -s $HOME/.dot-files/_psqlrc $HOME/.psqlrc
mkdir $HOME/.bin
ln -s $HOME/.dot-files/switch_branches.sh $HOME/.bin/sb

mkdir -p $HOME/.config
mkdir -p $HOME/.config/k9s
ln -s \
  $HOME/.dot-files/_config/nvim \
  $HOME/.config
ln -s \
  $HOME/.dot-files/_config/alacritty \
  $HOME/.config
ln -s \
  $HOME/.dot-files/_config/k9s/config.yaml \
  $HOME/.config/k9s
ln -s \
  $HOME/.dot-files/_config/k9s/views.yaml \
  $HOME/.config/k9s

# Linux specific
ln -s $HOME/.dot-files/_gpg-agent.conf $HOME/.gpg-agent.conf
ln -s \
  $HOME/.dot-files/_config/swaync \
  $HOME/.dot-files/_config/shikane \
  $HOME/.dot-files/_config/fuzzel \
  $HOME/.dot-files/_config/sway \
  $HOME/.dot-files/_config/user-dirs.dirs \
  $HOME/.dot-files/_config/waybar \
  $HOME/.dot-files/_config/pipewire \
  $HOME/.config
mkdir -p $HOME/.config/systemd
ln -s \
  $HOME/.dot-files/_config/systemd/user/* \
  $HOME/.config/systemd/user
systemctl --user enable shikane.service
systemctl --user enable wl-paste.service
systemctl --user enable udiskie.service
systemctl --user enable swaync.service
systemctl --user enable blueman-applet.service
systemctl --user enable swayidle.service
systemctl --user enable batwarn.timer

sudo mkdir /etc/greetd
sudo cp /home/brandon/.dot-files/etc/greetd/* /etc/greetd/
systemctl enable greetd.service

# Mac specific
ln -s $HOME/.dot-files/_config/flashspace $HOME/.config/

ln -s $HOME/.bashrc $HOME/.bash_profile
cat '#!/usr/bin/env bash' >> $HOME/.bashrc.local
cat 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.bashrc.local
cat '[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"' >> $HOME/.bashrc.local
```

Useful References:
- https://wiki.archlinux.org/title/Systemd-boot
- https://wiki.archlinux.org/title/Greetd
- https://wiki.archlinux.org/title/Thunderbolt -- May need to tweak UEFI ThunderBolt settings especially add pcie_port_pm=off to kernel params
- https://wiki.archlinux.org/title/Power_management/Wakeup_triggers#Instantaneous_wakeup_after_suspending
- https://wiki.archlinux.org/title/Systemd#systemd-tmpfiles_-_temporary_files
