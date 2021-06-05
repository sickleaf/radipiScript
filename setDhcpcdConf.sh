#!/bin/bash

tempPath=/tmp/dhcpcd.conf
dstPath=/etc/dhcpcd.conf

backupPath=${dstPath%/*}/dhcpcd.conf_backup_`date +%Y%m%d_%H%M%S`

autoFlag=$1

echo ! make backup
cp -pv ${dstPath} ${backupPath}

[ $? -eq 0 ] && echo backup done ${backupPath}
echo 

[ ! -f ${backupPath} ] && { echo "!! backup failed. run script with sudo command."; exit 1; }

#  $ ip route show default
## > default via 192.168.11.100 dev wlan0 src 192.168.11.189 metric 303 
##               [router]                     [ipaddr]
##

ipaddr=$(ip route show default | grep -Eo "[0-9\.]{5,}" | tail -1)
router=$(ip route show default | grep -Eo "[0-9\.]{5,}" | head -1)

if [ "${autoFlag}" = "" ]; then
	echo "input ipaddr"
	read ip
	[ "$(echo ${ip} | grep -Eo "[0-9\.]{5,}")" = "" ] && { echo "!! ip format error. enter ipaddress correctly."; exit 1; }
	ipaddr=${ip}
fi

if [ "${autoFlag}" = "" ]; then
	echo "input router"
	read route 
	[ "$(echo ${route} | grep -Eo "[0-9\.]{5,}")" = "" ] && { echo "!! router format error. enter ipaddress correctly."; exit 1; }
	router=${route}
fi


echo ! ipaddr,router check
echo "ipaddr = ${ipaddr}"
echo "router = ${router}"
echo

cp -pv ${backupPath} ${tempPath}

patternA="^interface wlan0"
patternB="^static ip_address="
patternC="^static routers="
patternD="^static domain_name_servers="

[ "$(grep "${patternA}" ${tempPath})" = "" ] || sed -i "/${patternA}/d"  ${tempPath}
[ "$(grep "${patternB}" ${tempPath})" = "" ] || sed -i "/${patternB}/d"  ${tempPath}
[ "$(grep "${patternC}" ${tempPath})" = "" ] || sed -i "/${patternC}/d"  ${tempPath}
[ "$(grep "${patternD}" ${tempPath})" = "" ] || sed -i "/${patternD}/d"  ${tempPath}


sed -i "$ a interface wlan0\nstatic ip_address=$ipaddr/24\nstatic routers=$router\nstatic domain_name_servers=$router" ${tempPath} 

mv -v ${tempPath} ${dstPath} 
echo "dhcpcd file was set."
echo 

service dhcpcd restart

echo "now restarting..."
sleep 9

echo setting done!
