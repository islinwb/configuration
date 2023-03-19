#!/bin/sh

# 功能：设置业务网卡dns不注入 /etc/resolv.conf
#1) 输入cidr, 根据cidr查找网卡名(eth1)
#2) ifcfg-eth1 存在, 则写入 PEERDNS=no
#如果ifcfg-eth1 不存在, 则新增ifcfg-eth1 
#3) 清空/etc/resolv.conf  
#4) 重启网卡 service network restart

cidr=$P_CIDR
log_file="/usr/local/paas/networkDns/networkDns.log"

echo "`date '+%Y%m%d %H:%M:%S'` start =========" >> $log_file

#创建ifcfg-eth1文件
function createConfScript()
{
  confScritp=$1
  networkCard=$2
  
  sudo cat > $confScritp <<EOF
    TYPE=Ethernet
    PROXY_METHOD=none
    BROWSER_ONLY=no
    BOOTPROTO=dhcp
    DEFROUTE=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_FAILURE_FATAL=no
    IPV6_ADDR_GEN_MODE=stable-privacy
    NAME=$networkCard
    DEVICE=$networkCard
    ONBOOT=yes
    IPV6_PEERDNS=no
    PEERDNS=no
EOF

}


if [ -z "$cidr" ]; then
  echo "`date '+%Y%m%d %H:%M:%S'` cidr is empty, check env[P_CIDR]. exit"  >> $log_file
  exit -1
fi

#根据cidr查找网卡名
networkCard=`sudo ip route | grep $cidr | awk '{print $3}'`
if [ -z "$networkCard" ]; then
  echo "`date '+%Y%m%d %H:%M:%S'` networkCard not fount. cidr:$cidr" >> $log_file
  exit -1
fi

echo "`date '+%Y%m%d %H:%M:%S'` do PEERDNS networkCard: $networkCard  cidr:$cidr" >> $log_file

networkConfScript='/etc/sysconfig/network-scripts/ifcfg-'$networkCard
if [ -f "$networkConfScript" ]; then
  #禁止业务网卡注入dns
  sudo sed -i "s#IPV6_PEERDNS.*##g" $networkConfScript 
  sudo sed -i "s#PEERDNS.*##g" $networkConfScript 
  sudo sed -i "s@DNS1=@#DNS1=@g" $networkConfScript
  sudo echo "IPV6_PEERDNS=no" >> $networkConfScript 
  sudo echo "PEERDNS=no" >> $networkConfScript 
else
  #创建业务网卡配置文件
  createConfScript $networkConfScript $networkCard
fi

echo "`date '+%Y%m%d %H:%M:%S'` cat $networkConfScript" >> $log_file
cat $networkConfScript

#清空dns
echo "`date '+%Y%m%d %H:%M:%S'` clean /etc/resolv.conf  " >> $log_file
sudo cat /dev/null > /etc/resolv.conf  


#删除错误文件
echo "`date '+%Y%m%d %H:%M:%S'` clean *Wired_connection_1" >> $log_file
sudo rm -f  /etc/sysconfig/network-scripts/*Wired_connection_1

#重启网卡
echo "`date '+%Y%m%d %H:%M:%S'` service network restart" >> $log_file
sudo service network restart

sudo echo "optiions timeout:2" >>  /etc/resolv.conf
 
echo "`date '+%Y%m%d %H:%M:%S'` end   =========" >> $log_file