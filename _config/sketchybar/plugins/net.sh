#!/usr/bin/env bash

while read -r line; do
    sname=$(echo "$line" | awk -F  "(, )|(: )|[)]" '{print $2}')
    sdev=$(echo "$line" | awk -F  "(, )|(: )|[)]" '{print $4}')
    if [ -n "$sdev" ]; then
        ifout="$(ifconfig "$sdev" 2>/dev/null)"
        echo "$ifout" | grep 'status: active' > /dev/null 2>&1
        rc="$?"
        if [ "$rc" -eq 0 ]; then
            currentservice="$sname"
            currentdevice="$sdev"
            # assume ordered networks and stop at the first one
            if [ "$currentservice" ]; then
                break
            fi
        fi
    fi
done <<< "$(networksetup -listnetworkserviceorder | grep 'Hardware Port')"

if [ -z "$currentservice" ]; then
    sketchybar --set "$NAME" label="n/a"
    exit 0
fi

if [[ "$currentservice" == *"LAN"* ]]; then
    sketchybar --set "$NAME" label="ethernet"
    exit 0
fi

CURRENT_NETWORK=$(echo "$currentdevice" | ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}')

# Check if the current network is associated with an airport network
if echo "$CURRENT_NETWORK" | grep -q "You are not associated with an AirPort network"; then
    LABEL="N/A"
    sketchybar --set net_logo background.color=0xff3C3E4F --set net label.color=0xff1e1d2e
else
    sketchybar --set net_logo background.color=0xffE0A3AD --set net label.color=0xffECEFF4
    # Truncate the current network name if longer than 10 characters
    if [ "$(echo "$CURRENT_NETWORK" | awk '{ print length($1) }')" -gt 15 ]; then
        label=$(echo "$CURRENT_NETWORK" | awk '{ print substr($0, 1, 7) }')
        label=$(echo "$label" | sed 's/ *$//')
        LABEL="$label"...
    else
        LABEL=$(echo "$CURRENT_NETWORK" | awk '{ printf "%s", $1 }')
        # If there is a second word, print the first two characters followed by ...
        if [ "$(echo "$CURRENT_NETWORK" | awk '{ print NF }')" -gt 1 ]; then
            SECOND_WORD=$(echo "$CURRENT_NETWORK" | awk '{ printf "%s", substr($2, 1, 2) }')
            LABEL="$LABEL $SECOND_WORD..."
        fi
    fi
fi

sketchybar --set "$NAME" label="$LABEL"
