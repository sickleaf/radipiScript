#!/bin/bash

cd $(dirname $0)

spreadList=$(pwd)/spreadList
configPath=$(pwd)/webdir/static/config.js

source autoPlayByTime.sh ""
export -f getProgramLine

[ -f "${spreadList}" ] || { echo "spreadList($spreadList). run saveSpreadLocal.sh"; exit 1; }

checkOnly=$1

## echo mnt info  from configPath, and check list
echo  ""

i=1
for fl in `cat ${configPath} | grep Radipi.mnt | cut -d= -f3 | sed "s;.$;;g"`;
do
	[ -d ${fl} ] || printf "[mnt.%d:NOT EXISTS]" $i
	[ $(ls -l ${fl} | head -5 | wc -l) -gt 1 ] && printf  "[mnt.%d:OK]" $i || printf "[mnt.%d:NOT MOUNTED. (run sudo mount -a)]" $i
	printf "\t%s\n" ${fl}
	i=$((i+1));
done

## echo channel info  from configPath, and check file

i=1
for fl in `cat ${configPath} | grep Radipi.ch | cut -d= -f4 | sed "s;.$;;g"`;
do
	if [ -f ${fl} ]; then
		printf "[Ch.%d:OK]" $i

		nowDate=$(LC_ALL="" LC_TIME=C date '+%a:%H:%M:%S' )
		weekDay=$(echo $nowDate | cut -d ":" -f 1)
		nowTime=$(echo $nowDate | cut -d ":" -f 2-3)
	
		programInfo=$(getProgramLine "${fl}" "false" "false" "${weekDay}" "${nowTime}" )
		printf "\t%s\t%s\n" ${fl} ${programInfo}
	else
		printf "[Ch.%d:FILE NOT EXISTS]%s\n" $i ${fl}
	fi

	i=$((i+1));
done

# if args exists, exit
[ "${checkOnly}" = "" ] ||  exit 0;

## check which to edit, ch OR mnt
echo -e "\nselect which to edit(ch OR mnt)"

read editType

[ "${editType}" = "ch" -o "${editType}" = "mnt" ] || { echo -e "\ntype ch OR mnt. run this script again."; exit 1; }


if [ "${editType}" = "ch" ]; then
	echo -e "\nselect which channel edit(1,2,3)"
	
	read number
	
	[ "$(echo $number| grep -Eo [123])" = "" ] && { echo 1,2,3 not set.try again.; exit 1; }
	
	beforePath=$(cat ${configPath} | grep Radipi.ch | cut -d= -f4- | sed "s;.$;;g" | cut -d. -f2- | sed -n "${number}p")
	
	
	echo -e "\nset new path for Ch${number}"
	read afterPath
	
	echo -e "\nbefore:${beforePath}"
	echo -e " after:${afterPath}\n"
	
	sed -i "/Radipi.ch${number}/s;${beforePath};${afterPath};g" ${configPath}
	echo -e "replace done.\nRESULT"
	
	cat ${configPath} | grep Radipi.ch | cut -d= -f1,4- | sed "s;.$;;g" | cut -d. -f2- | tr "=" "\t"

else
	echo -e "\nselect which mnt edit(1,2,3)"
	
	read number
	
	[ "$(echo $number| grep -Eo [123])" = "" ] && { echo 1,2,3 not set.try again.; exit 1; }
	
	beforePath=$(cat ${configPath} | grep Radipi.mnt | cut -d= -f3- | sed "s;.$;;g" | cut -d. -f2- | sed -n "${number}p")
	
	
	echo -e "\nset new path for mnt${number}"
	read afterPath
	
	echo -e "\nbefore:${beforePath}"
	echo -e " after:${afterPath}\n"
	
	sed -i "/Radipi.mnt${number}/s;${beforePath};${afterPath};g" ${configPath}
	echo -e "replace done.\nRESULT"
	
	cat ${configPath} | grep Radipi.mnt | cut -d= -f1,3- | sed "s;.$;;g" | cut -d. -f2- | tr "=" "\t"


fi


