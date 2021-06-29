#!/bin/bash

tempPath=/tmp/.asoundrc
dstPath=/home/radipi/.asoundrc

backupPath=${dstPath%/*}/.asoundrc_backup_`date +%Y%m%d_%H%M%S`

echo ! make backup
cp -pv ${dstPath} ${backupPath} 2>/dev/null
[ $? -eq 0 ] && echo backup done ${backupPath}
echo 

cat > ${tempPath} <<EOF
defaults.bluealsa{
        service "org.bluealsa"
        device "@"
        profile "a2dp"
}
EOF

echo ! make ${dstPath}
echo "[type bluetoothAddress(XX:XX:XX:XX:XX:XX)]"
read blueAd 
sed -i "s;@;${blueAd};g" ${tempPath}

mv -v  ${tempPath} ${dstPath}

echo
echo setting done!"(${dstPath})"
