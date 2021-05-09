#!/bin/bash

type mpv > /dev/null

if [ $? -ne 0 ]; then
	echo 'mpv does not installed. run "apt install mpv -y"'
else
	echo "mpv installed."
fi

find /usr/share/sounds/* -name "*.wav" | grep Side | xargs -n1 mpv 
