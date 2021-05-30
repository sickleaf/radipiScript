#!/bin/bash

argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1*:streamingID/'show'> <2:duration(min)> <3:streamingInfoPath>"
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`


streamingID=$1
duration=$2
streamingInfoPath=${3:-"/home/radipi/Script/streamingListAll"}

# ! $streamingInfoPath not found
[ -f ${streamingInfoPath} ] || { echo "!! streamingURLInfo(${streamingURLInfo}) not found"; exit; }

# ! missing streamingID
[ "${streamingID}" = "" ] &&  { cat ${streamingInfoPath}; echo -e "\n${argsMessage}\n!! specify streamingID or 'show' for view all streamingInfo"; exit; }

# if ${streamingID} is "R" , get random stationName from ${streamingInfoPath}
[ "${streamingID}" = "R" ] && streamingID=$(cat ${streamingInfoPath} | cut -d, -f1 | shuf | head -1)

URL=$(cat ${streamingInfoPath} | grep -i ^${streamingID}, | cut -d, -f3)

[ "${streamingID}" = "show" ] && { cat ${streamingInfoPath}; exit; }

# ! nodata in URL
[ -n "${URL}" ] ||  { cat ${streamingInfoPath}; echo -e "\n!! URL for streamingID(${streamingID}) not matched.\ncheck streamingURLInfo(${streamingURLInfo})"; exit; }

# ! streamingID duplcate
[ $(echo "${URL}" | grep -c ^ ) -eq 1 ] ||  { cat ${streamingInfoPath}; echo -e "\n!! streamingURL matched by streamingID(${streamingID}) is not unique.\n check streamingURLInfo(${streamingURLInfo})";   exit; }


mpvOption=" --no-video --msg-level=all=info "

bluetoothaddr=$(hcitool con | grep -Eo "[0-9A-F:]{9,}")

[ "$(echo $bluetoothaddr)" = "" ] || mpvOption=${mpvOption}" --audio-device=alsa/bluealsa "

dOption=""

# set duration for dOption
[ -n "${duration}" ] && dOption=" --length=$((duration*60))"

# echo execution
[ -n "${duration}" ] && echo "play ${streamingID} (duration: ${duration}min)" || echo "play ${streamingID} (no duration specified)" 

mpv ${mpvOption} ${dOption} ${URL}
