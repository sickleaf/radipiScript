#!/bin/bash

if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo "(1)resourcePath (2)play numbers[default=100, if number=0, show filelist] (3)sort option[s:sort/n:name order/r:reverse order] (4)filter keyword"
	echo "(resourcePath must exist)"
	echo ""
	echo -e "[ex1. play 3 files in /mnt/radipiDrive shuffle] \n$0 /mnt/radipiDrive 3 s\n"
	echo -e "[ex2. play files in /mnt/radipiDrive in reverse order] \n$0 /mnt/radipiDrive '' r\n"
	echo -e "[ex3. play files in /usr/share/sounds , whose name include 'Left', in numeric order] \n$0 /usr/share/sounds '' n Left\n"
	echo -e "[ex4. show playlist in /usr/share/sounds , whose name include 'Left', in normal order] \n$0 /usr/share/sounds 0 n Left\n"
	exit 1
fi

resourcePath=$1
number=${2:-0}
sortOption=${3:-"s"}
keyword=${4:-""}

namePattern="-name *.mp3 -o -name *.m4a -o -name *.wav "

player=mpv
mpvSocket=/tmp/remocon.socket

bluetoothOp=""
[ "$(hcitool con | grep ACL)" = "" ] || bluetoothOp="--audio-device=alsa/bluealsa"

option="--no-video --msg-level=all=info --idle=no ${bluetoothOp} --input-ipc-server=${mpvSocket}"


[ -d "${resourcePath}" ] || echo "resourcePath("${1}") not exist.";

if [ "${sortOption}" = "s" ]; then
	find "${resourcePath%/*}/" -type f ${namePattern} | shuf | grep "${keyword}" | head -$(expr ${number}) | xargs -I@ ${player} ${option} "@";
	[ "$number" -eq 0 ] && find "${resourcePath%/*}/" -type f ${namePattern} | shuf | grep "${keyword}"
else
	find "${resourcePath%/*}/" -type f ${namePattern} | sort -"${sortOption}" | grep "${keyword}" | head -$(expr ${number}) | xargs -I@ ${player} ${option} "@";
	[ "$number" -eq 0 ] && find "${resourcePath%/*}/" -type f ${namePattern} | sort -"${sortOption}" | grep "${keyword}"
fi
