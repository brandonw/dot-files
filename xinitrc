#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xset r rate 250 20
xrdb -merge ~/.Xresources
xbindkeys
xmodmap ~/.Xmodmap

# screen powersave
xset +dpms
xset dpms 0 0 300

upower -e

while true; do
	xsetroot -name "$(awk 'gsub(/,/,"") {print $3, $4}' <(acpi -b)) \
| Vol. $(awk '/Front Left:/ { gsub(/[\[\]]/,""); print $5}' <(amixer get Master)) \
| $(awk '/Mem:/ { print $3"/"$2"M" }' <(free -m)) \
| $(date +"%a, %b %d %r")"

	sleep 1s
done &

exec dwm
