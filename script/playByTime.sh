#!/bin/bash

radipiUser=radipi
scriptName=Script
scriptBASEPATH=/home/${radipiUser}/${scriptName}

configName=config
timetableName=timeTable
playradikoName=playradiko.sh

timetablePATH=${scriptBASEPATH}/${configName}/${timetableName}
playradikoPATH=${scriptBASEPATH}/${playradikoName}


nowDate=$(LANG=C;echo $(date '+%a:%H:%M:%S') )
weekDay=$(echo $nowDate | cut -d ":" -f 1)
nowTime=$(echo $nowDate | cut -d ":" -f 2-3)

reverseProgramList=$(tac ${timetablePATH}/${weekDay}.csv);

for program in ${reverseProgramList}
do
	programDate=$(echo ${program} | cut -d "," -f 1);
	if [ "${programDate}" \< "${nowTime}" ]; then
		programID=$(echo ${program} | cut -d "," -f 2);
		${playradikoPATH} -p ${programID}
		break;
	fi
done;
