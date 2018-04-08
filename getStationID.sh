#!/bin/bash


csvPath=$1

if [ $# -lt 1 ]; then
	echo "<<usage>>"
	echo "specify csv Path: $0 csvPath "
	exit 1
fi

programDirName=timeTable
nowDate=$(LANG=C;echo $(date '+%a:%H:%M:%S') )

weekDay=$(echo $nowDate | cut -d ":" -f 1)
nowTime=$(echo $nowDate | cut -d ":" -f 2-3)

reverseProgramList=$(tac $csvPath/${weekDay}.csv);

for program in $reverseProgramList
do
	programDate=$(echo ${program} | cut -d "," -f 1);
	if [ "${programDate}" \< "${nowTime}" ]; then
		programID=$(echo ${program} | cut -d "," -f 2);
		echo $programID
		break;
	fi
done;
