#!/bin/bash

cd $(dirname $0)

spreadList=$(pwd)/spreadList
configPath=$(pwd)/webdir/static/config.js

[ -f "${spreadList}" ] || { echo "spreadList($spreadList). run saveSpreadLocal.sh"; exit 1; }

## echo channel info  from configPath, and check file
echo "ch"
cat ${configPath} | grep Radipi.ch | cut -d= -f1,4- | sed "s;.$;;g" | cut -d. -f2- | tr "=" "\t"

i=1
for fl in `cat ${configPath} | grep Radipi.ch | cut -d= -f4 | sed "s;.$;;g"`;
do
	[ -f ${fl} ] && echo -e [Ch.$i] exists. || echo -e [Cn.$i] does not exists.
	i=$((i+1));
done


## echo mnt info  from configPath, and check list
echo -e "\nmnt"
cat ${configPath} | grep Radipi.mnt | cut -d= -f1,3- | sed "s;.$;;g" | cut -d. -f2- | tr "=" "\t"

i=1
for fl in `cat ${configPath} | grep Radipi.mnt | cut -d= -f3 | sed "s;.$;;g"`;
do
	[ -d ${fl} ] && echo -e [mnt.$i] exists. || echo -e [mnt.$i] does not exists.
	i=$((i+1));
done

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


