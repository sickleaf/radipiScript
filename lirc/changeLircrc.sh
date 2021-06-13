#!/bin/bash

editFile=$1
editnum=${2:-"1"}


argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1*:lircFile> <2:editTime(number)/allFlag('all')>"
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`
 
[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 

[ -f "${editFile}" ] && cat ${editFile} || { echo "editFile not exists."; exit; }

allFlag="false"
[ "$editnum" = "all" ] && allFlag=true

[ ! ${allFlag} = "true" -a "$(echo $editnum | grep -o [0-9]*)" = "" ] && { echo "editnum is not number. input NUMBER ONLY." ; exit; }

buttonList=$(cat ${editFile} | grep "button" | cut -d"=" -f2 | sed "s; ;;g" | tr "\n" "," | sed "s;.$;;g")

[ "$buttonList" = "" ] && { echo "button name not found in ${editFile}." ; exit; }

[ ${allFlag} = "true" ] && editnum=$(grep -c "button =" ${editFile})

for i in $(seq $editnum);
do
	echo ""
	
	if [ ! "${allFlag}" = true ]; then
		printf "[%d/%d]select button name(select from %s). if you want to quit, input 'q'.\n" "$i" "$editnum" "$buttonList"
		read rcode
		
		[ "$rcode" = "q" ] && break;
		[ "$(grep $rcode ${editFile})" = "" ] && { echo "rcode($rcode) not exists in editFile."; exit; }
	else
		rcode=$(cat ${editFile} | grep "button" | cut -d"=" -f2 | sed "s; ;;g" | sed -n "${i}p" )
	fi
	
	
	printf "\n%s\n" "<<BEFORE[${rcode}]>>"
	sed -n "/button = ${rcode}/{N;N;p}" ${editFile}
	
	echo ""
	
	printf "%s\n" "select command type"
	printf "%s\n" "(1)playradiko.sh  (2)playStreaming.sh  (3)playLocalfile.sh  (4)playFM.sh  (5)setVolume.sh  (6)killsound.sh  (7)other"
	
	read flag
	[ "$(echo $flag | grep -Eo [1234567])" = "" ] && { echo select from 1to7.try again.; exit 1; }
	
	[ "${flag}" -eq 1 ] && defaultCommand="/home/radipi/Script/killsound.sh TERM; /home/radipi/Script/playradiko.sh <*ID> <duration>"
	[ "${flag}" -eq 2 ] && defaultCommand="/home/radipi/Script/killsound.sh TERM; /home/radipi/Script/playStreaming.sh <*ID> <duration>"
	[ "${flag}" -eq 3 ] && defaultCommand="/home/radipi/Script/killsound.sh TERM; /home/radipi/Script/playLocalfile.sh <*filePath> <filenumber> <sortOption> <filter>"
	[ "${flag}" -eq 4 ] && defaultCommand="/home/radipi/Script/killsound.sh TERM; /home/radipi/Script/playFM.sh <*frequency(MHz)>"
	[ "${flag}" -eq 5 ] && defaultCommand="/home/radipi/Script/setVolume.sh <*absolute/relative volume level> <-/+(relative flag)>"
	[ "${flag}" -eq 6 ] && defaultCommand="/home/radipi/Script/killsound.sh TERM"
	[ "${flag}" -eq 7 ] && defaultCommand=$(sed -n "/button = ${rcode}/{N;N;p}" ${editFile} | tail -1 | cut -d"=" -f2-)
	
	
	echo "original:"${defaultCommand}
	read -p "(command) " -e -i "${defaultCommand}" CMDLINE
	
	
	sed -i "/button = ${rcode}/{N;N;s/config.*/config = ${CMDLINE//\//\\/}/g;}" ${editFile}
	
	
	printf "\n%s\n" "<<AFTER[${rcode}]>>"
	sed -n "/button = ${rcode}/{N;N;p}" ${editFile}
	i=$((i+1));
done

echo -e "\n"setting done!"(${editFile})"
#sed  /button = ${buttonName}/{N;N;s/config.*/config = ${script}/g;} ${fileName}

