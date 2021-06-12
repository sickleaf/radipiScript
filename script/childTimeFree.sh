#!/bin/bash

wholeAACList="$1"
secondAACFile="$2"
restAACFile="$3"

ffmpegOption=" -y  -protocol_whitelist file,pipe,crypto   -f concat -i - -c copy -loglevel fatal "

wholeDirPath=$(echo ${wholeAACList} | rev | cut -d/ -f2- | rev)
tmpDirPath="${wholeDirPath}/tmp"
cd ${tmpDirPath}

### get startTime for re-download aac
startTime=$(find ${tmpDirPath} -type f | sort | head -1 | grep -o "_[0-9]*_" | awk -F_ '$0=$2' | sed -e "s/../&:/g" -e "s/:$//g" )

# download aac files for secondAACFile
cat ${wholeAACList} | 
tail -n +13 | 
head  -108 | 
xargs -P 4 -L 1 wget -q --timeout=10 -nc -P ${tmpDirPath} 2> /dev/null

## check aac file downloaded (second)
secondRetryList="(no missing file)"

for num in `seq 108`; do
	pointTime=$(date -d "2000/01/01 ${startTime} $((5*num))sec" +"%H%M%S")

	# if file whose name includes ${pointTime} does not exists, add to ${secondRetryList}
	if [ ! -f ${tmpDirPath%/}/*_${pointTime}_* ]; then
		secondRetryList="${secondRetryList}@${pointTime}"; 
	fi
done

echo second:${secondRetryList}

# if secondRetryList exists, re-download
if [ ! "$(echo ${secondRetryList} | grep '@')" = "" ]; then
	for rlist in `echo ${secondRetryList} | sed "s;^@;;g" | tr @ "\n"`; do
		url=$(cat ${wholeAACList} | grep "_${rlist}_" )
		#echo $(cat ${wholeAACList} | grep "_${rlist}_" )
		[ -n "${url}" ] && wget -q -nc -P ${tmpDirPath} ${url}
	done
fi

echo concating aac files for secondAACFile

# concat 13-120 AAC files into secondAACFile
cat ${wholeAACList} | 
tail -n +13 | 
head -108 |
awk -F"/" '{print "file "$NF}' | 
ffmpeg ${ffmpegOption} ${secondAACFile} | bash

echo "generated:"${secondAACFile}

# download aac files for restAACFile
cat ${wholeAACList} | 
tail -n +121 | 
xargs -P 4 -L 1 wget -q --timeout=10 -nc -P ${tmpDirPath} 2> /dev/null

## check aac file downloaded (last)
lastRetryList="(no missing file)"

fileNum=$(grep -c ^ ${wholeAACList})
for num in `seq 108 $(( ${fileNum} -1 ))`; do
	pointTime=$(date -d "2000/01/01 ${startTime} $((5*num))sec" +"%H%M%S")

	# if file whose name includes ${pointTime} does not exists, add to ${lastRetryList}
	if [ ! -f ${tmpDirPath%/}/*_${pointTime}_* ]; then
		lastRetryList="${lastRetryList}@${pointTime}"; 
	fi
done

echo last:${lastRetryList}

# if lastRetryList exists, re-download
if [ ! "$(echo ${lastRetryList} | grep '@')" = "" ]; then
	for rlist in `echo ${lastRetryList} | sed "s;^@;;g" | tr @ "\n"`; do
		url=$(cat ${wholeAACList} | grep "_${rlist}_" )
		#echo $(cat ${wholeAACList} | grep "_${rlist}_" )
		[ -n "${url}" ] && wget -q -nc -P ${tmpDirPath} ${url}
	done
fi

echo concating aac files for restAACFile

# concat rest AAC files into restAACFile
cat ${wholeAACList} | 
tail -n +121 | 
awk -F"/" '{print "file "$NF}' | 
ffmpeg ${ffmpegOption} ${restAACFile} | bash

echo "generated:"${restAACFile}

cd ${wholeDirPath}

rm -r ${tmpDirPath} 
