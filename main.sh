#!/bin/bash

printf "main starts"

sysctl net.ipv4.ip_forward=1

#first version
#sudo ./recheck_modem  

#second version
sudo ./nft/my_firewall.sh wwan0 eth0
sudo ./recheck_modem_mbim.sh
