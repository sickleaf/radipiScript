#!/bin/bash

argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1*:streamingURLInfo> <2:streamingID(if missing, cat streamingURLInfo)> <3:duration(min)>"
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 

streamingURLInfo=$1
streamingID=$2
duration=$3

# ! $1 not found
[ -f ${streamingURLInfo} ] || { echo "!! streamingURLInfo(${streamingURLInfo}) not found"; exit; }

# if ${streamingID} is blank, check ${streamingURLInfo}
[ -n "${streamingID}" ] || { cat ${streamingURLInfo}; exit; }

# if ${streamingID} is "R" , get random stationName from ${streamingURLInfo}
[ "${streamingID}" = "R" ] && streamingID=$(cat ${streamingURLInfo} | cut -d, -f1 | shuf | head -1)

URL=$(cat ${streamingURLInfo} | grep -i ^${streamingID}, | cut -d, -f3)

# ! nodata in URL
[ -n "${URL}" ] ||  { cat ${streamingURLInfo}; echo -e "\n!! URL for streamingID(${streamingID}) not matched.\ncheck streamingURLInfo(${streamingURLInfo})"; exit; }

# ! streamingID duplcate
[ $(echo "${URL}" | grep -c ^ ) -eq 1 ] ||  { cat ${streamingURLInfo}; echo -e "\n!! streamingURL matched by streamingID(${streamingID}) is not unique.\n check streamingURLInfo(${streamingURLInfo})";   exit; }


mpvOption=" --no-video --msg-level=all=info "

bluetoothaddr=$(hcitool con | grep -Eo "[0-9A-F:]{9,}")

[ "$(echo $bluetoothaddr)" = "" ] || mpvOption=${mpvOption}" --audio-device=alsa/bluealsa "

dOption=""

# set duration for dOption
[ -n "${duration}" ] && dOption=" --length=$((duration*60))"

# echo execution
[ -n "${duration}" ] && echo "play ${streamingID} (duration: ${duration}min)" || echo "play ${streamingID} (no duration specified)" 

mpv ${mpvOption} ${dOption} ${URL}
