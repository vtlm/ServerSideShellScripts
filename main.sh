#!/bin/bash

printf "main starts"

#first version
#sudo ./recheck_modem  

#second version
sudo ./my_firewall.sh wwan0 eth0
sudo ./recheck_modem_mbim.sh
