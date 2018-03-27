#!/bin/bash

#$1	resourcePath(absolute path)
#$2	number

extention="mp3"
defaultNumber=100;
player=mpv
option='--no-video --msg-level=all=info'

resourcePath="$1"
number="$2"
namePattern="*."${extention}

if [ "$2" = '' ]; then 
	number=$defaultNumber;
fi

fileList=$(find ${resourcePath} -type f -name ${namePattern} | shuf | head -$(expr ${number}));

for fileName in ${fileList}
do
	${player} ${option} ${fileName};
done;
