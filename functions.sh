#!/bin/bash

get_modem_number() {
    IFS='/ ' read -r _ _ _ mm _ mn mt < <(mmcli -L)
#   echo 'echo: Modem number is' $mn
    printf "Modem number is: %s\n" $mn
}


ws_fastwebsocket_154_port=9084
ws_fastwebsocket_map_to_port=9080

ws_sockudo_153_port=61532
# ws_sockudo_153_map_to_port=9002

ws_sokudo_154_test_port=61541
ws_sokudo_map_to_test_port=9001
ws_sockudo_154_port=61542
ws_sockudo_map_to_port=9002


srv_ip_153=192.168.0.153
srv_ip_154=192.168.0.154

#
# dynamic building bcs with dest addr
#
set_ports_forward(){

    printf "set_ports_forward: forwarding from %s\n" $1
    #RTSP over TCP fwd
    nft add table my_nat
    nft 'add chain my_nat prerouting { type nat hook prerouting priority -100 ; }'
    nft 'add chain my_nat postrouting { type nat hook postrouting priority 100 ; }'

    nft flush table ip my_nat

#mqtt
#    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 9080 } dnat 192.168.0.12:80
#    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 1883 } dnat 192.168.0.12:1883

#home assistant
    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 8123 } counter dnat 192.168.0.14:8123

    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { $ws_sockudo_153_port } counter dnat $srv_ip_153:$ws_sockudo_map_to_port

    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { $ws_fastwebsocket_154_port } counter dnat $srv_ip_154:$ws_fastwebsocket_map_to_port
    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { $ws_sokudo_154_test_port } counter dnat $srv_ip_154:$ws_sokudo_map_to_test_port
    nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { $ws_sockudo_154_port } counter dnat $srv_ip_154:$ws_sockudo_map_to_port
#cams RTSP over TCP
    #nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5554 } dnat 192.168.0.111:554
    #nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5556 } dnat 192.168.0.152:554
    #nft add rule my_nat prerouting iif wwan0 ip daddr $1 tcp dport { 5557 } dnat 192.168.0.113:554

    nft add rule my_nat postrouting masquerade
}
