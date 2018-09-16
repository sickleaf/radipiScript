#!/bin/bash

#$1	dirID	
#$2	number

if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo "specify (1)resourcePath and (2)file numbers for continuous play"
	echo "(file numbers is optional"
	echo "ex. play 5 songs in /mnt/radipiDrive -> $0 /mnt/radipiDrive 5"
	exit 1
fi

# NAME

SCRIPTNAME=Script;

CONFIGNAME=config;
CSVFILENAME=dirList.csv;

# USER

RADIPIUSER=radipi;

# DIR

SCRIPTPATH=/home/${RADIPIUSER}/${SCRIPTNAME}

# DIR

CONFIGDIR=${SCRIPTPATH}/${CONFIGNAME}

dirCSVPath=${CONFIGDIR}/${CSVFILENAME}

dirID=$1

extention="mp3"
defaultNumber=100;
player=mpv
mpvSocket=/tmp/mpv.socket
option="--no-video --msg-level=all=info --idle=no --input-ipc-server=${mpvSocket}"


resourcePath="";
resourcePath=$(cat ${dirCSVPath} | grep "${dirID}," | cut -d, -f 3);

if [ resourcePath = "" ];then
	echo "ID ${dirID} doesn't matched. check ${dirCSVPath}";
	exit 1
fi

number="$2"
namePattern="*."${extention}

if [ "$2" = '' ]; then 
	number=$defaultNumber;
fi

echo "play ${number} files."
echo "[if you want to stop playing, press Ctrl + C ]"

fileList=$(find ${resourcePath} -type f -name ${namePattern} | shuf | head -$(expr ${number}) );

echo "$fileList" | while read fileName
do
	echo "$fileName"
	${player} ${option} "${fileName}";
done;

