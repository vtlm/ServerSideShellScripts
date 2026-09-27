#!/bin/bash


sysctl net.ipv4.ip_forward=1

cnt=0
modem_reconnect_cnt=0
ip_addr_changes_cnt=0
prev_ip4=""


#./set_iptables eth0 wwan0
#./set_forward_hass

. ./functions.sh

reconnect_modem(){
#    printf "\nReconnect modem\n"
#    printf "\nStop mbim network\n"
    res=$(mbim-network /dev/cdc-wdm0 stop)
	printf "\nResult of mbim stop %s\n" "${res[@]}"
# |grep succes
    sleep 4
    printf "\nStart mbim network\n"
    mbim-network /dev/cdc-wdm0 start |grep succes
    ((modem_reconnect_cnt=modem_reconnect_cnt+1))
}


check_usb_cdc(){
    cdc_line_cnt=$(lsusb -t |grep mbim |wc -l)
    printf "\nlsusb cdc drivers total lines: %d\n" $((cdc_line_cnt))

    if [[ $((cdc_line_cnt)) -ne 0 ]]; then
        printf "\nlsusb cdc drivers %d\n" $((cdc_line_cnt))
        usb_cdc_presents=1
    else
        printf "\nno lsusb cdc drivers %d\n" $((cdc_line_cnt))
        usb_cdc_presents=0
    fi

}


restart_wwan0() {
    ip link set wwan0 down
    ip a flush dev wwan0
    ip link set wwan0 up
    ip a add $bearer_ip4 dev wwan0
    ip r add default dev wwan0 metric 20

#    if [ "$prev_ip4" != "" ]; then
#      iptables -t nat -D POSTROUTING -o eth0 -p tcp --dport 8123 -d 192.168.0.11 -j SNAT --to-source $prev_ip4
#    fi
#
#    iptables -t nat -A POSTROUTING -o eth0 -p tcp --dport 8123 -d 192.168.0.11 -j SNAT --to-source $bearer_ip4

    prev_ip4=$bearer_ip4
    # ((prev_ip4=bearer_ip4))
    ./nft/my_firewall.sh wwan0 eth0

    set_ports_forward $bearer_ip4

    ((ip_addr_changes_cnt=ip_addr_changes_cnt+1))
}



for ((;;))
do

    printf "\ncycle %d\n" $cnt
    printf "\nmodem_reconnect_cnt %d ip addr changes: %d\n" $modem_reconnect_cnt $ip_addr_changes_cnt
    ((cnt=cnt+1))

    check_usb_cdc

    printf "usb_cdc_presents %d\n" $((usb_cdc_presents))

    if [[ $((usb_cdc_presents)) = 1 ]]; then
        printf "\ncdc=1"
        
        # bearer_ip4=$(mmcli -m $mn -b $bearer_number |grep "address" |grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
        bearer_ip4=$( mbimcli -d /dev/cdc-wdm0 -p --query-ip-configuration= |grep "IP" |grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}/[0-9]{1,2}")
    #    printf "\nBearer IPv4:" $((bearer_ip4)) 

        if [ "$bearer_ip4" == "" ]; then
#           printf "/nBearer IPv4 is empty:" $((bearer_ip4))
            reconnect_modem

        else

            wwan_ip4=$(ip a |grep wwan0 |grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}/[0-9]{1,2}")
            echo "wwan IPv4:" $wwan_ip4

            if [ "$bearer_ip4" != "$wwan_ip4" ]; then
                echo "bearer" $bearer_number IP not equal to wwan IP
                echo "Reconfigure wwan"
                restart_wwan0
            else
                echo "Bearer & wwan have same ip4:" $bearer_ip4
            fi


        fi 

    fi

    sleep 10
done
