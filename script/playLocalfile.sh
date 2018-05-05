#!/bin/bash

#$1	resourcePath(absolute path)
#$2	number

if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo "specify (1)resourcePath and (2)file numbers for continuous play"
	echo "(file numbers is optional"
	echo "ex. play 5 songs in /mnt/radipiDrive -> $0 /mnt/radipiDrive 5"
	exit 1
fi


extention="mp3"
defaultNumber=100;
player=mpv
mpvSocket=/tmp/mpv.socket
option="--no-video --msg-level=all=info --idle=no --input-ipc-server=${mpvSocket}"

resourcePath="$1"
number="$2"
namePattern="*."${extention}

if [ "$2" = '' ]; then 
	number=$defaultNumber;
fi

fileList=$(find ${resourcePath} -type f -name ${namePattern} | shuf | head -$(expr ${number}) );

echo "$fileList" | while read fileName
do
	echo "$fileName"
	${player} ${option} "${fileName}";
done;

