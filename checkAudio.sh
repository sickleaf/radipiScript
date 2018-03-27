#!/bin/bash

player=mpv;

type mpv > /dev/null
if [ $? -ne 0 ]; then
	echo 'mpv does not installed. run "apt-get install mpv"'
else
	echo "If you want to stop playing, Press [Ctrl + C]"
fi

${player} --no-video https://www.youtube.com/watch?v=B2D3lGOrdVQ
