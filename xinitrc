#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xset r rate 250 20
xrdb -merge ~/.Xresources
xbindkeys
xmodmap ~/.Xmodmap

while true; do
	xsetroot -name "$( date +"%a %b %d %r")"
	sleep 1s
done &

exec dwm
