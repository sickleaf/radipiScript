#!/bin/bash

#$1	volume number(absolute) OR  +/-
#$2	increase/decrease value

if [ "$1" = '+' ]; then 
	amixer set Master `expr $2`%+
fi

if [ "$1" = '-' ]; then 
	amixer set Master `expr $2`%-
fi

expr "$1" + 1 > /dev/null 2>&1
if [ $? -lt 2 ]
then
	amixer set Master `expr $1`%
fi
