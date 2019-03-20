#!/bin/bash

#############################################
# This is a simple battery warning script.  #
# It uses i3's nagbar to display warnings.  #
#                                           #
# @author agribu                            #
#############################################

# set Battery
BATTERY=$(ls /sys/class/power_supply/ | grep '^BAT0')

# set full path
ACPI_PATH="/sys/class/power_supply/$BATTERY"

# get battery status
STAT=$(cat $ACPI_PATH/status)

# get remaining energy value
REM=`grep "POWER_SUPPLY_ENERGY_NOW" $ACPI_PATH/uevent | cut -d= -f2`

# get full energy value
FULL=`grep "POWER_SUPPLY_ENERGY_FULL_DESIGN" $ACPI_PATH/uevent | cut -d= -f2`

# get current energy value in percent
PERCENT=`echo $(( $REM * 100 / $FULL ))`

# set error message
MESSAGE="Battery at $PERCENT%. Charge soon or power down will commence."

# set energy limit in percent, where warning should be displayed
LIMIT="10"

# show warning if energy limit in percent is less then user set limit and
# if battery is discharging
if [ $PERCENT -le $LIMIT ] && [ "$STAT" == "Discharging" ]; then
    DISPLAY=:0.0 /usr/bin/i3-nagbar -m "$(echo $MESSAGE)" -t warning
fi
