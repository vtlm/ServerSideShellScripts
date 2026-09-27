#!/bin/bash

printf "main starts"

sysctl net.ipv4.ip_forward=1

#first version
#sudo ./recheck_modem  

#second version
<<<<<<< HEAD
sudo ./my_firewall.sh wwan0 eth0
=======
sudo ./nft/my_firewall.sh wwan0 eth0
>>>>>>> 4ce68964a9b0d029004034bb70604c2e0aac8301
sudo ./recheck_modem_mbim.sh
