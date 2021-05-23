#!/bin/bash

cd $(dirname $0)

allPath=$(pwd)/streamingListAll
basePath=$(pwd)/streamingListBase
configPath=$(pwd)/webdir/static/config.js

[ -f "${allPath}" ] || { echo allPath not found.$allPath; exit 1; }
[ -f "${basePath}" ] || { echo basePath not found.$basePath; exit 1; }

echo "swtich to allPath OR basePath (1 OR 2)"
echo 1:allPath
echo 2:basePath
echo

read flag

[ "$(echo $flag | grep -Eo [12])" = "" ] && { echo 1,2 not set.try again.; exit 1; }

if [ "${flag}" -eq 1 ]; then
	echo switch to "${allPath}"
	sed -i "s;${basePath##*/};${allPath##*/};g" ${configPath}
	echo swithc done "${configPath}"
else
	echo switch to "${basePath}"
	sed -i "s;${allPath##*/};${basePath##*/};g" ${configPath}
	echo swithc done "${configPath}"

fi
