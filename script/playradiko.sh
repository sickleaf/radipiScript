#!/bin/bash

trap 'rm -rf /tmp/radiko-$$' EXIT

radikoCredentialPath=/home/radipi/radikoInfo/

ROOTPATH=$(cd $(dirname $0); pwd);
funcScript="${ROOTPATH}"/radikoScript.sh

argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1*:stationID/RandomFlag> <2:duration>"
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; }

. ${funcScript}

stationID=$1
duration=$2

# if mail is blank, type mail
if [ ! -f "${ROOTPATH}/mail" ]; then
	echo ! mail is blank [type mailAddress]
	read mailAddress
	echo "${mailAddress}" > "${ROOTPATH}/mail"
fi

#read mail
mail=$(cat "${ROOTPATH}/mail")

# if stationID="R" , get stationID at random
[ "${stationID}" = "R" ] && stationID=`getRandomStationID`


# if workdir is blank, set temporary workdir
if [ "${workdir}" = "" ]; then
	workdir=/tmp/radiko-$$
	mkdir -p ${workdir}
	chmod 777 ${workdir}
fi

echo "[station]${stationID}"
echo "[mail]${mail}"
echo "[duration]${duration:-"DEFAULT"}"
echo

# check enpass / set password
checkEnpass $radikoCredentialPath

# save ${cookieFile}
getCookieFile $workdir $mail $cookiefile

# save ${auth1}
getAuth1 $workdir

# save ${auth2}
getAuth2 $workdir

# play radiko
playRadiko $workdir $stationID $cookiefile $auth1 $duration
