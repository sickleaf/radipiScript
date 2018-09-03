#!/bin/bash

scriptDir=$(cd $(dirname $0); pwd);
cd ${scriptDir}

configScript=config.sh
. ./${configScript}

functionScript=function.sh
. ./${functionScript}


dirPath="$1"
tmpDirPath=${dirPath}/tmp


wholeAACList=${dirPath}/${wholeName}.txt
echo $wholeAACList

secondAACList=${dirPath}/${secondName}.txt
secondAACFile=${dirPath}/${secondName}.aac

restAACList=${dirPath}/${restName}.txt
restAACFile=${dirPath}/${restName}.aac

if [ $# -lt 1 ]; then
  echo "usage : use this script via [timefreeParent.sh]"
  echo "ex -> timefreeParent.sh channel_name fromtime totime"
  exit 1
fi



cat ${wholeAACList} | tail -n +13 | head -n 100 | while read line; do wget --no-verbose -nc -P ${tmpDirPath} "$line"; done

	fixed_second_string=""
	ls ${tmpDirPath}/* | tail -n +13 | head -n 100 > ${secondAACList}
	while read line;
		do 
			fixed_second_string="${fixed_second_string}"" -cat ""$line"
	done < ${secondAACList}

	MP4Box -sbr ${fixed_second_string} -new ${secondAACFile}


cat ${wholeAACList} | tail -n +113 | while read line; do wget --no-verbose -nc -P ${tmpDirPath} "$line"; done

	fixed_rest_string=""
	ls ${tmpDirPath}/* | tail -n +113 > ${restAACList}
	while read line;
		do 
			fixed_rest_string="${fixed_rest_string}"" -cat ""$line"
	done < ${restAACList}

	MP4Box -sbr ${fixed_rest_string} -new ${restAACFile}

