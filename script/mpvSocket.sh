#!/bin/bash


# speed -> setProperty needed
# 	/tmp/remocon.socket speed 2.00 1
# time-pos -> setProperty needed
# 	/tmp/remocon.socket time-pos 100 1

# seek -> setProperty not needed
# /tmp/remocon.socket seek -20

socketPath="$1"
myCommand="$2"
setpFlag="$4"


if [ $# -lt 2 ]; then
	echo "<<usage>>"
	echo "case 1[don't require set_property] : $0 mpvSocketPath Command value "
	echo "ex. seek -120sec ->  $0 /tmp/remocon.socket seek -20 "
	echo ""
	echo "case 2[require set_property] : $0 mpvSocketPath Comand value 0 "
	echo "ex. set speed 2.00 ->  $0 /tmp/remocon.socket speed 2.00 0 "
	echo ""
	echo "case 3[specific case] : $0 mpvSocketPath command value"
	echo "ex1. seek 20sec ->  $0 /tmp/remocon.socket skipsec 20"
	echo "ex2. seek -20sec ->  $0 /tmp/remocon.socket skipsec -20"
	echo "ex3. seek 10% ->  $0 /tmp/remocon.socket skipper 10"
	echo "ex4. seek -10% ->  $0 /tmp/remocon.socket skipper -10"
	echo "ex5. back t0 start ->  $0 /tmp/remocon.socket start"
	echo ""
	exit 1;
fi

if [ $# -eq 4 ]; then
	baseCommand="set_property"
	subCommand=\"$2\",
	setValue="$3"
else
	baseCommand="$2"
	subCommand=""
	setValue="$3"
fi	

if [ "${myCommand}" = "skipsec" ]; then
	baseCommand=seek
	subCommand=""
	setValue="$3"
fi

if [ "${myCommand}" = "skipper" ]; then
	baseCommand=seek
	subCommand=""
	setValue="$3,\"relative-percent\""
fi

if [ "${myCommand}" = "start" ]; then
	baseCommand=seek
	subCommand=""
	setValue="0,\"absolute-percent\""
fi



string="{ \"command\": [\"${baseCommand}\", ${subCommand} ${setValue}] }"

echo $string

echo $string | socat - "${socketPath}"
