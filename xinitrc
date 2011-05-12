#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xset r rate 250 20
xsetroot -cursor_name left_ptr
wmname LG3D
xrdb -merge ~/.Xresources

while true; do
	xsetroot -name "$( date +"%a %b %d %r")"
	sleep 1s
done &

numlockx &

#exec xmonad
exec dwm
