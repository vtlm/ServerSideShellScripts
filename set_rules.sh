#!/bin/bash

. ./functions.sh

user_wwan_ip4=$1

if [ "$user_wwan_ip4" != "" ]; then
    printf "User WWAN IP4: %s\n" $user_wwan_ip4
    set_ports_forward $user_wwan_ip4
else
    # wwan_ip4=$(ip a |grep wwan0 |grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}/[0-9]{1,2}")
    wwan_ip4=$(ip a |grep wwan0 |grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
    printf "WWAN IP4: %s\n" $wwan_ip4
    set_ports_forward $wwan_ip4
fi