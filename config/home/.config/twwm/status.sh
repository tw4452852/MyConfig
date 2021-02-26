#!/usr/bin/env bash

POLL=1 # in second
NIC=enp1s0
DISK=nvme0n1

function _time {
  echo -n `date '+%F %a %R'`
}

function _mem {
  free -t | awk 'NR == 2 {printf("MEM:%.2f%"), $3/$2*100}'
}

function _cpu {
  top -b -n1 | grep '^%Cpu' | awk '{printf("CPU:%.2f%"), 100-$8}'
}

function _network {
  ifstat $NIC | grep $NIC | awk '{printf("RX:%s TX:%s"), $6, $8}'
}

# == main loop ==
current_status=""

while true; do
  new_status="$(_time) $(_mem) $(_cpu) $(_network)"
  [ "$current_status" = "$new_status" ] || xsetroot -name "$new_status"
  current_status="$new_status"
  sleep $POLL
done
