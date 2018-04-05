#!/bin/bash


# speed -> setProperty needed
# 	/tmp/mpv.socket speed 2.00 1
# time-pos -> setProperty needed
# 	/tmp/mpv.socket time-pos 100 1

# seek -> setProperty not needed
# /tmp/mpv.socket seek -20

socketPath="$1"
setpFlag="$4"


if [ $# -lt 2 ]; then
	echo "<<usage>>"
	echo "case 1[don't require set_property] : $0 mpvSocketPath Command value "
	echo "ex. seek -120sec ->  $0 /tmp/mpv.socket seek -20 "
	echo ""
	echo "case 2[require set_property] : $0 mpvSocketPath Comand value 0 "
	echo "ex. set speed 2.00 ->  $0 /tmp/mpv.socket speed 2.00 0 "
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

string="{ \"command\": [\"${baseCommand}\", ${subCommand} ${setValue}] }"

echo $string

echo $string | socat - "${socketPath}"
