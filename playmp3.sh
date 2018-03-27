#!/bin/bash

#$1	resourcePath(absolute path)
#$2	number

extention="mp3"
defaultNumber=100;
player=mpv
option='--no-video --msg-level=all=warn'

resourcePath="$1"
number="$2"
namePattern="*."${extention}

if [ "$2" = '' ]; then 
	number=$defaultNumber;
fi

fileList=`find $1 -type f -name ${namePattern}`;

cat fileList | shuf | head -`expr $2` | while read line; do ${player} ${option} "$line"; done
