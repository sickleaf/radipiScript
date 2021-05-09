#!/bin/bash

forceFlag=${1:-""}

if [ "$(ps aux | grep flask[P]age)" = "" -o ! "${forceFlag}" = "" ]; then
	kill -TERM $(ps aux | grep flask[P]age | awk '$0=$2')
	nohup python3 /home/radipi/Script/webdir/flaskPage.py > /home/radipi/flasklog 2>&1 &
fi
