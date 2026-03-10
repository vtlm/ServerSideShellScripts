#!/bin/bash

get_modem_number() {
    IFS='/ ' read -r _ _ _ mm _ mn mt < <(mmcli -L)
#   echo 'echo: Modem number is' $mn
    printf "Modem number is: %s\n" $mn
}



set_mqtt_forward(){
    #RTSP over TCP fwd
    nft add table my_nat
    nft 'add chain my_nat prerouting { type nat hook prerouting priority -100 ; }'
    nft 'add chain my_nat postrouting { type nat hook postrouting priority 100 ; }'
#mqtt
    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 9080 } dnat 192.168.0.11:80
    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 1883 } dnat 192.168.0.11:1883
#home assistant
    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 8123 } dnat 192.168.0.14:8123
    #nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5554 } dnat 192.168.0.111:554
    #nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5556 } dnat 192.168.0.152:554
    #nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5557 } dnat 192.168.0.113:554
    nft add rule my_nat postrouting masquerade
}
