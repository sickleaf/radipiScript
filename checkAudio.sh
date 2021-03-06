#!/bin/bash

volume=${1-80}

ROOTPATH=$(cd $(dirname $0); pwd);
bash ${ROOTPATH}/script/setVolume.sh ${volume}

type mpv > /dev/null

if [ $? -ne 0 ]; then
	echo 'mpv does not installed. run "apt install mpv -y"'
else
	echo "mpv installed."
fi

bluetoothaddr=$(hcitool con | grep -Eo "[0-9A-F:]{9,}")

mpvOption=""

[ "$(echo $bluetoothaddr)" = "" ] || mpvOption=" --audio-device=alsa/bluealsa"


find /usr/share/sounds/* -name "*.wav" | grep Side | xargs -n1 mpv  ${mpvOption}
