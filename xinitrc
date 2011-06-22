#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xset r rate 250 20
wmname LG3D
numlockx
xrdb -merge ~/.Xresources

xinput --set-prop 9 245 7
xset m 3/1 1
#sudo lmctl -b 005 -8

while true; do
	xsetroot -name "$( date +"%a %b %d %r")"
	sleep 1s
done &

exec dwm
