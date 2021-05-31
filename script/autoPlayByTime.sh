#!/bin/bash

argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1*:filePath> <2:just flag> <3:checknext flag('true', or sth else)> \n\n [[justflag, checknextflag]]\n false false:\tplay already started.\n true false:\tplay just only. if line not found, do nothing. \n false true:\tshow upcoming line. \n true true:\tshow upcoming line."
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 

dstPath=/home/radipi/Script/spreadList

[ -f "${dstPath}" ] || { echo "!! dstPath($dstPath) not found."; exit; } 

filePath=$1
justFlag=${2:-"false"}
checknextFlag=${3:-"false"}

for i in `seq 7`;
do
	da=$(LC_ALL="" LC_TIME=C date -d "$i day" +%a)

	[ $(grep -c "$da," ${filePath}) -lt 1 ] &&  { echo -e "!! filePath($filePath) format error.\nset at least one line for [[$da]]."; exit; } 
done


function getProgramLine(){

	argsMessage="usage: <1*:filePath> <2:justFlag> <3:checkNext> <4:weekDay> <5:nowTime>"
	leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

	[ $# -ge ${leastArgs} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 


	filePath=${1:-"/tmp/sheet1"}
	justFlag=${2:-"false"}
	checkNext=${3:-"false"}
	weekDay=${4}
	nowTime=${5}

	# set value for grepJust 
	[ "${justFlag}" = "true" ] && grepJust=",${nowTime},"

	if [ "${checknextFlag}" = true ]; then
		# nowTime is smaller than programLine = show future programLine.
		programLine=$(cat ${filePath} |
		grep ${weekDay}, | 		# grep today's programLine
		sort -t, -k3,3h |		# sort human numeric sort
		awk -v FS="," -v nowTime=${nowTime} 'nowTime <= $3 {print}' | # list up data AFTER $nowTime
		head -1 ) # get upcoming one

	else
		# nowTime is greater than programLine = show present programLine
		programLine=$(cat ${filePath} |
		grep ${weekDay}, | 		# grep today's programLine
		sort -t, -k3,3h |		# sort human numeric sort
		awk -v FS="," -v nowTime=${nowTime} 'nowTime >= $3 {print}' | # list up data BEFORE $nowTime
		tail -1 | # get most recent one 
		grep ${grepJust} ) # if grep

		# if programLine="",justFlag=false, checknextFlag=false; play already started from yesterday
		if [ "${programLine}" = "" -a ! "${justFlag}" = true ]; then
			weekDay=$(LC_ALL="" LC_TIME=C date -d "1day ago" '+%a')

			programLine=$(cat ${filePath} |
			grep ${weekDay}, | 		# grep today's programLine
			sort -t, -k3,3h |		# sort human numeric sort
			tail -1 | # get most recent one
			grep ${grepJust} ) # if grep

		fi
		
	fi

	preInfo=""
	[ "${checkNext}" = "true" -a ! "${programLine}" = "" ] && preInfo="[NextInfo] "

	echo "${preInfo}${programLine}"

}

[ -f "${filePath}" ] || { echo -e "\n${argsMessage}\n!! filePath not found. check result of saveSpreadLocal.sh"; exit; } 

radikoScript=/home/radipi/Script/playradiko.sh
streamingScript=/home/radipi/Script/playStreaming.sh
playLocalfileScript=/home/radipi/Script/playLocalfile.sh
lircrcPath=/tmp/lircrc

killsoundScript=/home/radipi/Script/killsound.sh

nowDate=$(LC_ALL="" LC_TIME=C date '+%a:%H:%M:%S' )

weekDay=$(echo $nowDate | cut -d ":" -f 1)
nowTime=$(echo $nowDate | cut -d ":" -f 2-3)

grepJust=","
[ "${justFlag}" = "true" ] && grepJust=",${nowTime},"


# filePath, checkNext, justFlag, weekDay, nowTime, 
programLine=`getProgramLine "${filePath}" "${justFlag}" "${checknextFlag}" "${weekDay}" "${nowTime}"`

#echo "${programLine}"
#echo

#    cmd="cat /tmp/sheet1 | grep Sun, | sort -t, -k3,3r | awk -v FS=',' -v nowTime=$(LC_ALL='' LC_TIME=C date '+%H:%M' ) 'nowTime <= $3 {print}' | tail -1 | sed 's;,,;;g; s;^;[NextInfo] ;g'"


if [ "${checknextFlag}" = true ]; then

	#get next days's 1st line (if only checknextFlag=true(do not play))
	weekDay=$(LC_ALL="" LC_TIME=C date -d "1day" '+%a')
	nowTime=00:00
	
	[ "${programLine}" = "" ] && programLine=$(getProgramLine "${filePath}" "false" "true" "${weekDay}" "${nowTime}")
	echo ${programLine}

else

	playType=$(echo ${programLine} | cut -d, -f 2);
	programTime=$(echo ${programLine} | cut -d, -f 3);
	programID=$(echo ${programLine} | cut -d, -f 4);
	shArgs=$(echo ${programLine} | cut -d, -f 6- | tr "," " ");

	# if play line exists, killsound
	[ "${programLine}" = "" ] || echo "bash ${killsoundScript} TERM" | bash

	case "$playType" in
	"radiko" ) echo "${radikoScript} ${programID} ${shArgs} ";echo; echo "bash ${radikoScript} ${programID}" | bash ;;
	"stream" ) echo "${streamingScript} ${shArgs} ${programID}" ;echo; echo "bash  ${streamingScript} ${shArgs} ${programID}" | bash ;; 
	"localfile" ) echo "${playLocalfileScript} ${shArgs}"; echo; echo "bash ${playLocalfileScript} ${shArgs}" | bash ;; 
	"lircrc" ) cat ${lircrcPath} | grep -E "^${programID}" | sed -n 1p | cut -d# -f2-  | bash ;;
	esac

fi


