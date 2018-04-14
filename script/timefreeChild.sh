#!/bin/sh

dirPath=$1
tmpDirPath=${dirPath}/tmp

wholeAAC="${dirPath}/wholeAAC.txt"

firstAAC="${dirPath}/firstAAC.txt"
secondAAC="${dirPath}/secondAAC.txt"
restAAC="${dirPath}/restAAC.txt"

firstAACfile="${dirPath}/firstAAC.aac"
secondAACfile="${dirPath}/secondAAC.aac"
restAACfile="${dirPath}/restAAC.aac"


if [ $# -lt 1 ]; then
  echo "usage : use this script via [timefreeParent.sh]"
  echo "ex -> timefreeParent.sh channel_name fromtime totime"
  exit 1
fi



cat ${wholeAAC} | tail -n +13 | head -n 100 | while read line; do wget --no-verbose -nc -P ${tmpDirPath} "$line"; done

	fixed_second_string=""
	ls ${tmpDirPath}/* | tail -n +13 | head -n 100 > ${secondAAC}
	while read line;
		do 
			fixed_second_string="${fixed_second_string}"" -cat ""$line"
	done < ${secondAAC}

	MP4Box -sbr ${fixed_second_string} -new ${secondAACfile}


cat ${wholeAAC} | tail -n +113 | while read line; do wget --no-verbose -nc -P ${tmpDirPath} "$line"; done

	fixed_rest_string=""
	ls ${tmpDirPath}/* | tail -n +113 > ${restAAC}
	while read line;
		do 
			fixed_rest_string="${fixed_rest_string}"" -cat ""$line"
	done < ${restAAC}

	MP4Box -sbr ${fixed_rest_string} -new ${restAACfile}

