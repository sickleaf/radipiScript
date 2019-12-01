#!/bin/bash

# read ${radioMode}
source /tmp/radioMode.txt

playradikoName=playradiko.sh

scriptDir=$(cd $(dirname $0); pwd);

timetablePATH=$1
manualRunFlag=$2
playradikoPATH=${scriptDir}/${playradikoName}

if [ ! -f ${playradikoPATH} ]; then
	echo "<<ERROR>>${playradikoPATH} not found. place ${playradikoName} at ${scriptDir}"
	exitFlag=true;
fi

if [ ${1:-""} = "" ]; then
	echo "<<ERROR>>timetablePATH is blank."
	exitFlag=true;
fi

if [ ${manualRunFlag:-""} != "true" ]; then
	if [ ${radioMode:-""} != "true" ]; then
		echo "<<ERROR>>radioMode is not true.(if you want to run manually, set true after timetablePATH."
		exitFlag=true;
	fi
fi

nowDate=$(LC_ALL="" LC_TIME=C date '+%a:%H:%M:%S' )
weekDay=$(echo $nowDate | cut -d ":" -f 1)
nowTime=$(echo $nowDate | cut -d ":" -f 2-3)

if [ ${exitFlag:-"false"} = "true" ]; then
	exit
fi

if [ ${manualRunFlag:-"false"} = "true" ]; then
	programList=$(cat ${timetablePATH}/${weekDay}.csv);
	else
	programList=$(tac ${timetablePATH}/${weekDay}.csv);
fi



# program := 0100,TBS
# programDate=0100
# programID=TBS
for program in ${programList}
do
	programDate=$(echo ${program} | cut -d "," -f 1);
	if [ "${programDate}" = "${nowTime}" ] || [ ${manualRunFlag:-"false"} = "true" ]; then
		killall --signal KILL -q rtmpdump playradiko.sh
		programID=$(echo ${program} | cut -d "," -f 2);
		nohup ${playradikoPATH} -p ${programID} >> /tmp/autoPlay.log &
		exit
	fi
done;
