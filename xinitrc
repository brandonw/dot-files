#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx
#

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

. .xprofile
. .profile
xrdb -merge .Xresources
xmodmap .Xmodmap

while true; do
	xsetroot -name "$(sys-status)"
done &
exec dwm
