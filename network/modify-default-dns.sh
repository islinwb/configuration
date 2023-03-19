#!/bin/sh
# /etc/dhcp/dhclient-exit-hooks.d/modify-default-dns.sh
## Prevent interface to create default dns entries

case ${interface} in
  eth0)
  ;;
  eth1)
  ;;
  *)
    if [[ ! -f /etc/dhcp/dhclient-exit-hooks.d/${interface}-dns-configured ]]; then
       printf "remove default dns for ${interface}\n" 
       echo "TYPE=Ethernet" > /etc/sysconfig/network-scripts/ifcfg-${interface}
       echo "NAME=${interface}" >> /etc/sysconfig/network-scripts/ifcfg-${interface}
       echo "DEVICE=${interface}" >> /etc/sysconfig/network-scripts/ifcfg-${interface}
       echo "IPV6_PEERDNS=no" >> /etc/sysconfig/network-scripts/ifcfg-${interface}
       echo "PEERDNS=no" >> /etc/sysconfig/network-scripts/ifcfg-${interface}
       touch /etc/dhcp/dhclient-exit-hooks.d/${interface}-dns-configured
       echo 'RES_OPTIONS="timeout:2"' >> /etc/sysconfig/network
       cat /dev/null > /etc/resolv.conf  
       systemctl restart network 
    fi
  ;;
esac