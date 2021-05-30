#!/bin/bash

argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1:filePath> <2:just flag>"
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 

dstPath=/home/radipi/Script/spreadList

[ -f "${dstPath}" ] || { echo "!! dstPath($dstPath) not found."; exit; } 

filePath=$1
justFlag=$2

[ -f "${filePath}" ] || { echo -e "\n${argsMessage}\n!! filePath not found. check result of saveSpreadLocal.sh"; exit; } 

radikoScript=/home/radipi/Script/playradiko.sh
streamingScript=/home/radipi/Script/playStreaming.sh
playLocalfileScript=/home/radipi/Script/playLocalfile.sh
lircrcPath=/tmp/lircrc

killsoundScript=/home/radipi/Script/killsound.sh

# get programLine
## check time. assume 23:30 and 23:00
## 23:30 (when 23:01, [ 23:30 > 23:01 ] => true. skip.)
## 23:00 (when 23:01, [ 23:00 > 23:01 ] => false. stop here.)
##       (when 23:00, [ 23:00 > 23:00 ] => false. stop here.)

nowDate=$(LC_ALL="" LC_TIME=C date '+%a:%H:%M:%S' )
weekDay=$(echo $nowDate | cut -d ":" -f 1)
nowTime=$(echo $nowDate | cut -d ":" -f 2-3)

grepJust=","
[ "${justFlag}" = "true" ] && grepJust=",${nowTime},"

programLine=$(cat ${filePath} |
grep ${weekDay}, | 		# grep today's programLine
				# programLine is CSV (comma separated) / use $nowTime as filter condition
awk -v FS="," -v nowTime=${nowTime} 'nowTime >= $3 {print}' | 
grep ${grepJust} |
sort -t, -k 3,3r |
sed -n 1p)

echo "${programLine}"
echo

playType=$(echo ${programLine} | cut -d, -f 2);
programTime=$(echo ${programLine} | cut -d, -f 3);
programID=$(echo ${programLine} | cut -d, -f 4);
shArgs=$(echo ${programLine} | cut -d, -f 6- | tr "," " ");

#killsound
[ "$programLine" = "" ] || echo "bash ${killsoundScript} TERM" | bash

case "$playType" in
		# set 'true "" /tmp'
"radiko" ) echo "${radikoScript} ${programID} ${shArgs} ";echo; echo "bash ${radikoScript} ${programID}" | bash ;;
"stream" ) echo "${streamingScript} ${shArgs} ${programID}" ;echo; echo "bash  ${streamingScript} ${shArgs} ${programID}" | bash ;; 
"localfile" ) echo "${playLocalfileScript} ${shArgs}"; echo; echo "bash ${playLocalfileScript} ${shArgs}" | bash ;; 
"lircrc" ) cat ${lircrcPath} | grep -E "^${programID}" | sed -n 1p | cut -d# -f2-  | bash ;;
esac


