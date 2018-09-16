#!/bin/bash

# $1

if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo "specify Streaming URL ID described in config/streamingList.csv"
	echo "ex. play J1 GOLD% ->  $0 J1GOLD"
	exit 1
fi

# NAME

SCRIPTNAME=Script;

CONFIGNAME=config;
CSVFILENAME=streamingList.csv;

# USER

RADIPIUSER=radipi;

# DIR

SCRIPTPATH=/home/${RADIPIUSER}/${SCRIPTNAME}

# DIR

CONFIGDIR=${SCRIPTPATH}/${CONFIGNAME}

# PLAYER

player=mpv
option='--no-video --msg-level=all=info'

streamID=$1;

streamDataPath=${CONFIGDIR}/${CSVFILENAME}

streamURL=$(cat ${streamDataPath} | grep ${streamID} | cut -d, -f 3);
streamCheck=$(echo ${streamURL} | wc -w)

if [ ${streamCheck} -eq 0 ]; then
	echo "** [ERROR] streaming URL not found **";
	exit 1;
else
	${player} ${option} ${streamURL};
fi

