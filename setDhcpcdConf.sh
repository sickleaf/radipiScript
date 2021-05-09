#!/bin/bash

tempPath=/tmp/dhcpcd.conf
dstPath=/etc/dhcpcd.conf

backupPath=${dstPath%/*}/.asoundrc_backup_`date +%Y%m%d_%H%M%S`

echo ! make backup
cp -pv ${dstPath} ${backupPath}
echo backup done ${backupPath}
echo 

ipaddr=$(ip route show default | head -1)
router=$(ip route show default | tail -1)



echo ! make ${dstPath}
cp -pv ${backupPath} ${tempPath}
echo "[type bluetoothAddress(XX:XX:XX:XX:XX:XX)]"
read blueAd 
sed -i "s;@;${blueAd};g" ${tempPath}

sed "$ a interface wlan0\nstatic ip_address=$ipaddr/24\nstatic routers=$router\nstatic domain_name_servers=$router" ${tempPath}

mv -v  ${tempPath} ${dstPath}

echo
echo setting done!"(${dstPath})"
