#!/bin/bash

if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo "specify frequency(MHz)"
	exit 1
fi

if [ $# -eq 2 -a $1 = "-n" ]; then
	freq=$2e6
	echo "pass"
else
	ID=$1
#	freq=`echo `
fi

player=rtl_fm
option1=' -f '
option2=' -M wbfm -s 200000 -r 48000 | aplay -r 48000 -f S16_LE '

sh -c "${player} ${option1} ${freq} ${option2}";
