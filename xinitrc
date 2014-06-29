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

. /home/brandon/.xprofile
. /home/brandon/.profile
xrdb -merge /home/brandon/.Xresources
xmodmap /home/brandon/.Xmodmap

while true; do
	xsetroot -name "$(sys-status)"
done &
exec dwm
