#!/bin/bash

if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo -e "(1*)resourcePath\n(2)play numbers[if number=0, show filelist]\n(3)sort option[s:shuffle/n:name order/r:reverse order/l:latest order]\n(4)filter keyword\n(5)show file length flag"
	echo ""
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
showFileLength=${5:-""}

# if "s" is set for sortOption, run sort -R
[ "${sortOption}" = "s" ] && sortOption="R"

namePattern="-name *.mp3 -o -name *.m4a -o -name *.wav "
regNamePattern=".*\.(mp3|wav|m4a)"

player=mpv
mpvSocket=/tmp/remocon.socket

bluetoothOp=""
[ "$(hcitool con | grep ACL)" = "" ] || bluetoothOp="--audio-device=alsa/bluealsa"

option="--no-video --msg-level=all=info --idle=no ${bluetoothOp} --input-ipc-server=${mpvSocket}"


[ -d "${resourcePath}" ] || echo "resourcePath("${1}") not exist.";


if [ "$number" -eq 0 ];then
	playOption=""
	if [ -n "${showFileLength}" ]; then
		playOption=" | xargs -I@ sh -c 'fLength=\$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 \"@\" ) \; export fLength\; printf \"[duration:%6d(%4dmin)] %s\n\" \$fLength \$( echo \$fLength / 60 | bc  ) \"@\"  ' 2>/dev/null"
	fi
else
	playOption=" | head -$(expr ${number}) | xargs -I@ ${player} ${option} \"@\" "
fi


if [ "${sortOption}" = "l" ]; then
	echo "find \"${resourcePath%/}/\" -regextype posix-extended -regex \"${regNamePattern}\" -printf \"%TY-%Tm-%Td_%TH:%TM %p\n\" | sort -r | cut -d \" \" -f2- | grep \"${keyword}\" " | sed "s;$;${playOption};g" | bash
	#[ "$number" -eq 0 ] && find "${resourcePath%/}/" -type f ${namePattern} | shuf | grep "${keyword}"
else
	echo "find \"${resourcePath%/}/\" -type f ${namePattern} | sort -\"${sortOption}\" | grep \"${keyword}\" " | sed "s;$;${playOption};g" | bash
	#find "${resourcePath%/}/" -type f ${namePattern} | sort -"${sortOption}" | grep "${keyword}" | head -$(expr ${number}) | xargs -I@ ${player} ${option} "@";
	#[ "$number" -eq 0 ] && find "${resourcePath%/}/" -type f ${namePattern} | sort -"${sortOption}" | grep "${keyword}"
fi
