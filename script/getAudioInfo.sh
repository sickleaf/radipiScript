#!/bin/sh

ROOTPATH=$(cd $(dirname $0); pwd);
streamingPath=/tmp/streamingList

funcScript=$(dirname ${ROOTPATH})/Script/mpvSocket.sh

#funcScript=$(dirname ${ROOTPATH})/common/sendSlack.sh
#. ${funcScript}

argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1:slackChannel>"
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 

channel=$1

#nowDate = HHMM
nowDate=$(LC_ALL="" LC_TIME=C date '+%a:%H:%M:%S')
#echo $nowDate

msg="<<${nowDate}>>\n"
grepMPV=$(ps aux | grep [m]pv | grep -v xargs | grep -v autoPlayByTime.sh | grep -o "socket .*" | cut -d\  -f2- )
mpvcheck=$(ps aux | grep [m]pv | grep -c ^)

# if grepMPV is blank, radiko OR streaming.
if [ ! $mpvcheck -eq 0 -a "${grepMPV}" = "" ]; then

	# radiko URL or streaming URL
	url=$(ps aux | grep [m]pv | awk '$0=$NF')

	grepMPV=$(echo $url | grep -f - ${streamingPath} | cut -d, -f1)

	if [ "${grepMPV}"  = "" ]; then

		#radiko
		grepMPV=$(ps aux | grep [m]pv | awk '$0=$NF' | cut -d/ -f4)
	else
		#streaming
		additionalInfo=$(omxplayer -i $url 2>&1  | grep -E "^ *(StreamTitle|icy-description)" | sed "s;   *;;g") 
	fi

fi


timepos=$(${funcScript} /tmp/remocon.socket get_property '"time-pos"' | grep -Eo "[0-9]+\." | sed "s;.$;;g")
percent=$(${funcScript} /tmp/remocon.socket get_property '"percent-pos"' | grep -Eo "[0-9]+\..")
remain=$(${funcScript} /tmp/remocon.socket get_property '"playtime-remaining"' | grep -Eo "[0-9]+\." | sed "s;.$;;g")
duration=$(${funcScript} /tmp/remocon.socket get_property '"duration"' | grep -Eo "[0-9]+\." | sed "s;.$;;g")

statusInfo=${percent}"%("${timepos}"sec/"${duration}"sec, last "${remain}"sec)"

echo ${grepMPV}
echo
echo ${statusInfo}

#msg=${msg}"playing:${grepMPV}\n${additionalInfo}\n"

#sendSlack ${channel} "${msg}" >> /tmp/audio.log
