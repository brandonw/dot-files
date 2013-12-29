#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx
#

. .xprofile
. .profile
xrdb -merge .Xresources
xmodmap .Xmodmap

while true; do
	xsetroot -name "$(sys-status) | $(date +"%a %b %_d %Y %I:%M:%S %p")"
done &
exec dwm
