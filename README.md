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
  kanshi \
  fuzzel \
  foot \
  wezterm \
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
  cmake

# Install aur-utils; AUR packges of use:
# ttf-dina-remastered
# bluetooth-autoconnect
```

## Install Git Repos

Clone and follow default bash+git install, except for bash-it which should be
integrated into .bashrc that will be symlinked below.

- https://github.com/asdf-vm/asdf
- https://github.com/Bash-it/bash-it
- https://github.com/junegunn/fzf

## Symlink Stuff

```sh
# Top Level
ln -s $HOME/.dot-files/_bashrc $HOME/.bashrc
ln -s $HOME/.dot-files/_gitconfig $HOME/.gitconfig
ln -s $HOME/.dot-files/_gitignore $HOME/.gitignore
ln -s $HOME/.dot-files/_ignore $HOME/.ignore
ln -s $HOME/.dot-files/_inputrc $HOME/.inputrc
ln -s $HOME/.dot-files/_profile $HOME/.profile
ln -s $HOME/.dot-files/_psqlrc $HOME/.psqlrc
mkdir $HOME/.bin
ln -s $HOME/.dot-files/switch_branches.sh $HOME/.bin/sb
# Linux specific
ln -s $HOME/.dot-files/_gpg-agent.conf $HOME/.gpg-agent.conf


# Config
mkdir -p $HOME/.config
ln -s \
  $HOME/.dot-files/_config/nvim \
  $HOME/.config
ln -s \
  $HOME/.dot-files/_config/foot \
  $HOME/.dot-files/_config/wezterm \
  $HOME/.dot-files/_config/swaync \
  $HOME/.dot-files/_config/fuzzel \
  $HOME/.dot-files/_config/sway \
  $HOME/.dot-files/_config/user-dirs.dirs \
  $HOME/.dot-files/_config/waybar \
  $HOME/.config
mkdir -p $HOME/.config/systemd
ln -s \
  $HOME/.dot-files/_config/systemd/user/* \
  $HOME/.config/systemd/user
systemctl --user enable kanshi.service
systemctl --user enable wl-paste.service
systemctl --user enable udiskie.service
systemctl --user enable swaync.service
systemctl --user enable blueman-applet.service
systemctl --user enable swayidle.service
systemctl --user enable batwarn.timer

sudo mkdir /etc/greetd
sudo cp /home/brandon/.dot-files/etc/greetd/* /etc/greetd/
systemctl enable greetd.service
```

Useful References:
- https://wiki.archlinux.org/title/Systemd-boot
- https://wiki.archlinux.org/title/Greetd
- https://wiki.archlinux.org/title/Thunderbolt -- May need to tweak UEFI ThunderBolt settings especially add pcie_port_pm=off to kernel params
