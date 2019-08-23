#!/bin/bash

function getPower() {
	now=`cat /sys/class/power_supply/BAT0/energy_now`
	full=`cat /sys/class/power_supply/BAT0/energy_full`
	if [[ `cat /sys/class/power_supply/AC/online` == "1" ]]; then
		ac_on="on"
	else
		ac_on="off"
	fi
	echo "BAT0: $[${now}*100/${full}]% AC: ${ac_on}"
}

while true; do
	d=`date`
	b=`getPower`
	xsetroot -name "${d} | ${b}"
	sleep 1
done
