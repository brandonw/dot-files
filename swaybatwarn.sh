#!/bin/bash

#############################################
# This is a simple battery warning script.  #
# It uses sway's nagbar to display warnings.#
#                                           #
# @author agribu                            #
#############################################

# set Battery
BATTERY=$(ls /sys/class/power_supply/ | grep '^BAT0')

# set full path
ACPI_PATH="/sys/class/power_supply/$BATTERY"

# get battery status
STAT=$(cat $ACPI_PATH/status)

if [ "$STAT" != "Discharging" ]; then
    exit 0
fi

# get remaining energy value
REM=`grep "POWER_SUPPLY_ENERGY_NOW=" $ACPI_PATH/uevent | cut -d= -f2`

# get full energy value
FULL=`grep "POWER_SUPPLY_ENERGY_FULL=" $ACPI_PATH/uevent | cut -d= -f2`

# get current energy value in percent
PERCENT=`echo $(( $REM * 100 / $FULL ))`

# set error message
CRITICAL_MESSAGE="Battery at $PERCENT%. Charge soon or power down will commence."
WARN_MESSAGE="Battery at $PERCENT%. Charge soon."

# set energy limit in percent, where warning should be displayed
CRITICAL_LIMIT="10"
WARN_LIMIT="15"

# set the expiration of the notification in ms. 0 means it does not expire
CRITICAL_EXPIRE="0"
WARN_EXPIRE="5000"

APP_NAME="Battery"

# show warning if energy limit in percent is less then user set limit and
# if battery is discharging
if [ $PERCENT -le $CRITICAL_LIMIT ]; then
    /sbin/notify-send --app-name=$APP_NAME --expire-time=$CRITICAL_EXPIRE --urgency=critical "$(echo $CRITICAL_MESSAGE)"
elif [ $PERCENT -le $WARN_LIMIT ]; then
    /sbin/notify-send --app-name=$APP_NAME --expire-time=$WARN_EXPIRE --urgency=normal "$(echo $WARN_MESSAGE)"
fi
