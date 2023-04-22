# Setup

## Install Packages

```sh
pacman -S \
  sway \
  bemenu \
  foot \
  mako \
  swayidle \
  swaylock \
  waybar \
  udiskie \
  pamixer \
  brightnessctl \
  ripgrep \
  xdg-user-dirs \
  xdg-utils \
  ttf-hack-nerd \
  ttf-jetbrains-mono-nerd \
  noto-fonts \
  noto-fonts-cjk  \
  noto-fonts-emoji \
  noto-fonts-extra \
  bash-completion \
  git

# Install auracle

auracle clone \
  clipman \
  grimshot \
  ly \
  wev \
  ttf-dina-remastered
```

## Install Git Repos

Clone and follow default bash+git install, except for bash-it which should be
integrated into .bashrc that will be symlinked below.

- https://github.com/asdf-vm/asdf
- https://github.com/Bash-it/bash-it
- https://github.com/junegunn/fzf
- password-store

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
# Linux specific
ln -s $HOME/.dot-files/_gpg-agent.conf $HOME/.gpg-agent.conf


# Config
mkdir -p $HOME/.config
ln -s \
  $HOME/.dot-files/_config/nvim \
  $HOME/.config
# Linux specific
ln -s \
  $HOME/.dot-files/_config/foot \
  $HOME/.dot-files/_config/mako \
  $HOME/.dot-files/_config/sway \
  $HOME/.dot-files/_config/user-dirs.dirs \
  $HOME/.dot-files/_config/waybar \
  $HOME/.config
mkdir -p $HOME/.config/systemd
ln -s \
  $HOME/.dot-files/_config/systemd/user/* \
  $HOME/.config/systemd/user
# Enable batwarn systemd timer
systemctl --user enable batwarn.timer
systemctl --user start batwarn.timer
```
