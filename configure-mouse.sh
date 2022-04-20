#!/bin/sh
#
# ~/.dot-files/configure-mouse.sh
#
# udevadm info -a -p /sys/devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:04F2:0939.0013/input/input40/mouse0

xsetroot -cursor_name left_ptr

# xinput list
# xinput list-props [dev-num]

xinput set-prop "Logitech USB Optical Mouse" "libinput Accel Speed" 1

TOUCH_DEVICE=$(xinput list | grep "\(Synaptics\|Touchpad\)" | perl -pe 's/.*↳ (.*?)\s*id=.*/\1/g')
xinput set-prop "$TOUCH_DEVICE" "libinput Tapping Enabled" 1
xinput set-prop "$TOUCH_DEVICE" "libinput Tapping Drag Lock Enabled" 1
xinput set-prop "$TOUCH_DEVICE" "libinput Natural Scrolling Enabled" 1
xinput set-prop "$TOUCH_DEVICE" "libinput Accel Speed" 0.5
