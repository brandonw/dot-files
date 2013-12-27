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
	xsetroot -name "$(date +"%a %b %_d %Y %I:%M:%S %p")"
	sleep 1m
done &
exec dwm
