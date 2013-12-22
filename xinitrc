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

#Run Network "enp2s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
#Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
#Run Memory ["-t","Mem: <usedratio>%"] 10
#Run Swap [] 10
