#!/bin/bash

# executable for nftables
nft="/usr/sbin/nft"

# wan and lan ports
wan=$1
lan=$2

# check empty arguments

if [ $# -eq 0 ]; then
    echo "Usage: ./firewall.sh wan lan"
    echo ""
    echo "i.e ./firewall.sh enp1s0 enp2s0"
    exit 1
fi

# flush/reset rules
${nft} flush ruleset

#create tables called "filter" for ipv4 and ipv6
${nft} add table ip filter

# one more table called 'nat' for our NAT/masquerading
${nft} add table nat

${nft} add chain filter input { type filter hook input priority 0 \; }
${nft} add chain filter output {type filter hook output priority 0 \; }
${nft} add chain filter forward {type filter hook forward priority 0 \; }
${nft} add chain filter postrouting {type filter hook postrouting priority 0 \; }
${nft} add chain nat postrouting {type nat hook postrouting priority 100 \; }

#FORWARDING RULESET

#forward traffic from WAN to LAN if related to established context
${nft} add rule filter forward iif $wan oif $lan ct state { established, related } accept

#forward from LAN to WAN always
${nft} add rule filter forward iif $lan oif $wan accept

#drop everything else from WAN to LAN
${nft} add rule filter forward iif $wan oif $lan counter accept

#INPUT CHAIN RULESET
#============================================================
${nft} add rule filter input ct state { established, related } accept

#always accept loopback
${nft} add rule filter input iif lo accept

#uncomment next rule to allow ssh in
${nft} add rule filter input tcp dport ssh counter log accept

#allow openvpn from wan
${nft} add rule filter input udp dport 1194 counter log accept

#accept HTTP, DNS, SSH, SMB and DHCP from LAN, since we have a webserver, dns and ssh running.
${nft} add rule filter input iif $lan tcp dport { 53, 22, 80, 3000, 9090, 443, 445 } counter log accept
#accept dns and dhcp on LAN
${nft} add rule filter input iif $lan udp dport { 53, 67, 68 } accept

#accept ICMP on the LAN
${nft} add rule filter input iif $lan ip protocol icmp accept

${nft} add rule filter input counter drop

#OUTPUT CHAIN RULESET
#=======================================================
# allow output from us for new, or existing connections.
${nft} add rule filter output ct state { established, related, new } accept

# Always allow loopback traffic
${nft} add rule filter output iif lo accept

#SET MASQUERADING DIRECTIVE
${nft} add rule nat postrouting masquerade
