#!/bin/sh
sysctl net.ipv4.ip_forward=1

#MQTT fwd
#nft 'add chain filter input { type filter hook input priority 100;}'
#sudo nft add rule filter input tcp dport 1883  tcp flags 0xff accept

#RTSP over TCP fwd
nft add table my_nat
nft 'add chain my_nat prerouting { type nat hook prerouting priority -100 ; }'
nft 'add chain my_nat postrouting { type nat hook postrouting priority 100 ; }'
nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 9080 } dnat 192.168.0.11:80
nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 1883 } dnat 192.168.0.11:1883
#nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5554 } dnat 192.168.0.111:554
#nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5556 } dnat 192.168.0.152:554
#nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5557 } dnat 192.168.0.113:554
nft add rule my_nat postrouting masquerade
#nft 'add rule my_nat prerouting iif eth0 ip daddr 192.168.0.13 udp sport { 6970,6971 } dnat 109.126.189.151'
#nft 'add rule my_nat prerouting iif wwan0 ip daddr 46.216.85.129 udp dport { 6970,6971 } dnat 192.168.0.111'

#history |cut -b8-
