#!/bin/bash


# speed -> setProperty needed
# 	/tmp/remocon.socket speed 2.00 1
# time-pos -> setProperty needed
# 	/tmp/remocon.socket time-pos 100 1

# seek -> setProperty not needed
# /tmp/remocon.socket seek -20

socketPath="/tmp/remocon.socket"
myCommand="$1"
setpFlag="$3"


if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo "case 1[don't require set_property] : $0 Command value "
	echo "ex. seek -20sec ->  $0 seek -20 "
	echo ""
	echo "case 2[require set_property] : $0 Comand value 0 "
	echo "ex. set speed 2.00 ->  $0 speed 2.00 0 "
	echo ""
	echo "case 3[specific case] : $0 command value"
	echo "ex1. seek 20sec ->  $0 skipsec 20"
	echo "ex2. seek -20sec ->  $0  skipsec -20"
	echo "ex3. seek 10% ->  $0  skipper 10"
	echo "ex4. seek -10% ->  $0  skipper -10"
	echo "ex5. back to start ->  $0  start"
	echo "ex6. speed up ->  $0 speed up"
	echo "ex7. speed down ->  $0 speed down"
	echo ""
	exit 1;
fi

if [ $# -eq 2 ]; then
	baseCommand=$1
	subCommand=""
	setValue="$2"
else
	baseCommand="$1"
	subCommand=""
	setValue="$2"
fi	

if [ "${myCommand}" = "start" ]; then
	baseCommand=seek
	subCommand=""
	setValue="0,\"absolute-percent\""
fi


if [ "${myCommand}" = "skipsec" ]; then
	baseCommand=seek
	subCommand=""
	setValue="$2"
fi

if [ "${myCommand}" = "skipper" ]; then
	baseCommand=seek
	subCommand=""
	setValue="$2,\"relative-percent\""
fi

if [ "${myCommand}" = "speed" ]; then
	baseCommand="set_property"
	subCommand=\"speed\",
	speed=$(bash /home/radipi/Script/mpvSocket.sh get_property \"speed\" 0 | sed 's/,.*//g' | cut -d: -f2 | tail -1);
	if [ "$2" = "down" ]; then
		speed=$(echo $speed-0.1 | bc | sed 's/^/0/g');
	else
		speed=$(echo $speed+0.1 | bc | sed 's/^/0/g');
	fi
	setValue="${speed}"
fi

string="{ \"command\": [\"${baseCommand}\", ${subCommand} "${setValue}"] }"

echo $string

echo $string | socat - "${socketPath}"
