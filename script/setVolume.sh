#!/bin/bash

#$1	volume level(absolute) OR  increase/decrease step(relative)
#$2	0(absolute) OR +/- (relative)
#$3	""(3.5mm,HDMI) OR 1(bluetooth)

# amixer -D  bluealsa sset 'TaoTronics TT-SK03 - A2DP' 80% 
# bluealsaControlName = $(amixer -D bluealsa | grep "mixer control" | cut -d "'" -f 2)


if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo "1) specify absolute volume level"
	echo "ex. set 90% ->  $0 90 "
	echo ""
	echo "2) specify relative volume level"
	echo "ex 1. increase 5% ->  $0 5 + "
	echo "ex 2. decrease 4% ->  $0 4 - "
#	echo ""
#	echo "case 1[absolute,wired] : $0 volLevel 0 "
#	echo "ex. set absolute volume(PCM) 90% ->  $0 90 0 "
#	echo ""
#	echo "case 2[relative,wired] : $0 stepNum +/-  "
#	echo "ex. decrease volume(PCM) 4% ) -> $0 4 - "
#	echo ""
#	echo "case 3[absolute,bluetooth] : $0 volLevel 0 0"
#	echo "ex. set absolute volume(bluealsa) 70% ->  $0 90 0 0"
#	echo ""
#	echo "case 4[relative,bluetooth] : $0 stepNum +/-  "
#	echo "ex. increase volume(bluealsa) 4% ) -> $0 4 + 0"
	exit 1
fi

bluetoothFlg=$(hcitool con | grep ACL | wc -l)

if [ ${bluetoothFlg} -eq 1 ]; then
	target=$(amixer -D bluealsa | grep " - A2DP" | head -1 | cut -d "'" -f 2)
	daemonOption=" -D  bluealsa "
	unit="%"
else
	target="Master"
	daemonOption=""
	unit="dB"
fi

#echo "daemonOption="${daemonOption}",target:\"${target}\""

if [ "$2" = '+' ]; then 
	sh -c "amixer ${daemonOption} sset \"${target}\" `expr $1`${unit}+"
elif [ "$2" = '-' ]; then 
	sh -c "amixer ${daemonOption} sset \"${target}\" `expr $1`${unit}-"
else
	sh -c "amixer ${daemonOption} sset \"${target}\" `expr $1`%"
fi
