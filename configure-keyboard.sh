#!/bin/sh
#
# ~/.dot-files/configure-keyboard.sh
#
# /devices/pci0000:00/0000:00:14.0/usb1/1-1

if [ -x /usr/bin/numlockx ]; then
	/usr/bin/numlockx on
fi
if [ -e ~/.xbindkeysrc ]; then
	xbindkeys
fi
if [ -e ~/.Xmodmap ]; then
	xmodmap ~/.Xmodmap > /dev/null 2>&1
fi

xset r rate 250 20
