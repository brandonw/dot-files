#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xset r rate 250 20
wmname LG3D
numlockx
xrdb -merge ~/.Xresources

start-pulseaudio-x11

xinput --set-prop 9 245 -1
#sudo lomoco -h

while true; do
	xsetroot -name "$( date +"%a %b %d %r")"
	sleep 1s
done &

exec dwm
