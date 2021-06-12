#!/bin/bash

trap 'rm -rf /tmp/radiko-$$' HUP INT KILL TERM

radikoCredentialPath=/home/radipi/radikoInfo/

ROOTPATH=$(cd $(dirname $0); pwd);
funcScript="${ROOTPATH}"/radikoScript.sh
childScriptPath="${ROOTPATH}"/childTimeFree.sh

argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1*:stationID/radikoURL> <2*:duration> <3:startTime(yyyymmddhhmmss)>"
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

usage="usage(1): TBS 120 20210615010000\nusage(2): https://radiko.jp/#!/ts/TBS/20210615010000 120\nusage(3): https://radiko.jp/share/?sid=TBS&t=20210615010000 120"

[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\n${usage}\" "; exit; }

. ${funcScript}

programInfo=$1
duration=$2
fromTime=$3

[ "$(echo ${fromTime} | grep -Eo [0-9]{14})" = "" ] && fromTime="";

# in case usage (2),(3) (programInfo=radiko URL), set stationID and fromTime
if [ -n "$(echo ${programInfo} | grep -Eo [0-9]{14})" ];then

	# URL copied from browser
	stationID=`echo ${programInfo} | grep -o sid.*\& | sed "y/\&/=/" |  cut -d= -f2`

	# URL copied from radiko function
	[ "${stationID}" = "" ] && stationID=`echo ${programInfo} | grep -o "\#\!/ts.*/" | cut -d/ -f3`

	# if fromTime is specified by both programInfo and fromTime, override by programInfo
	fromTime=`echo ${programInfo} | grep -Eo [0-9]{14}`
	
else
	stationID=${programInfo}
fi

# if fromTime is blank, exit
[ "${fromTime}" = "" ] && { echo -e "fromTime is blank. check radiko URL or startTime args."; exit; }

toTime=`echo ${fromTime} |
       	sed -e "s/[0-9][0-9]/ &/g" -e "s/ \([0-9][0-9]\) /\1/" | # separate startTime into YYYY_MM_DD_HH_MM_SS 
	       	awk '{printf("%d-%d-%d %d:%d:%d",$1,$2,$3,$4,$5,$6)}' | # YYYY-MM-DD HH:MM:SS format
	       	xargs -I@ date --date="@ ${duration}min" +%Y%m%d%H%M%S` # calculate time after $length minutes

# if mail is blank, exit
if [ ! -f "${ROOTPATH}/mail" ]; then
	echo ! mail is blank [type mailAddress]
	#exit 0
else
	#read mail
	mail=$(cat "${ROOTPATH}/mail")
fi


# if duration is less than 1, exit
[ "${duration}" -lt 1 ] && { echo -e "duration must be more than 1."; exit; }

# set temporary workdir
workdir=/tmp/radiko-$$
tmpDirPath=${workdir}/tmp
mkdir -p ${workdir} ${tmpDirPath}
chmod 777 ${workdir}


nowTime=`date '+%Y%m%d%H%M%S'`
if [ "${nowTime}" \< "${toTime}" ]; then
	echo "recording time not finished(nowTime:${nowTime},toTime:${toTime})";
	exit
fi

echo "stationID:${stationID}"
echo "duration:${duration}"
echo "fromTime:${fromTime}"
echo "  toTime:${toTime}"
echo "mail:${mail}"

baseinput="${workdir}/baseinput.m3u8"
wholeAACList="${workdir}/wholeAAC.txt"
firstAACfile="${workdir}/firstAAC.aac"
secondAACfile="${workdir}/secondAAC.aac"
restAACfile="${workdir}/restAAC.aac"

ffmpegOption=" -y  -protocol_whitelist file,pipe,crypto   -f concat -i - -c copy -loglevel fatal "

mpvSocket=/tmp/remocon.socket
mpvOption=" --no-video --msg-level=all=fatal --idle=no --input-ipc-server=${mpvSocket} "
bluetoothaddr=$(hcitool con | grep -Eo "[0-9A-F:]{9,}")
[ "$(echo $bluetoothaddr)" = "" ] || mpvOption=" --audio-device=alsa/bluealsa "${mpvOption}

ffmpegOption=" -y -protocol_whitelist file,pipe,crypto -f concat -i - -c copy -loglevel fatal "

# check enpass / set password
checkEnpass $radikoCredentialPath

# save ${cookieFile}
getCookieFile $workdir $mail $cookiefile

# save ${auth1}
getAuth1 $workdir

# save ${auth2}
getAuth2 $workdir

# play radiko
getStreamURL $workdir $stationID $fromTime $toTime


[ "$(grep -c ^ ${baseinput})" -lt 2 ] && { echo -e "baseinput not found. check stationID, dateTime is correct."; exit; }

stream_url=$(grep radiko ${baseinput})
rm ${baseinput}

wget -q $stream_url -O - | grep "radiko.jp/sound" > ${wholeAACList}


# download first 12 AAC files
cat ${wholeAACList} | head -n 12 | xargs -P 0 -L 1 wget -q -nc -P ${tmpDirPath}


cd ${tmpDirPath}
# concat first 12 AAC files(1 min)
cat ${wholeAACList} | 
head -12 | 
awk -F"/" '{print "file "$NF}' | 
ffmpeg ${ffmpegOption} ${firstAACfile} | bash

# start download/concat rest files background
bash "${childScriptPath}" "${wholeAACList}" "${secondAACfile}" "${restAACfile}" &

#play aac file
(mpv ${mpvOption} ${firstAACfile} ${secondAACfile} ${restAACfile}; cd; rm -rf "/tmp/radiko-$$" ) & 


