argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=${FUNCNAME[0]})\n'

getCookieFile(){
	echo "*"${FUNCNAME[0]}
	argsMessage=" usage: <1*:workDir> <2:mail> <3:cookiefileName>"
	leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

	[ $# -ge ${leastArgs} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 
	[ -d "$1" ] && cd $1 || { echo -e "!! \$1 not found.\nset workDir in \$1."; exit; }

	mail=$2
	cookiefile=${3:-"cookie.txt"}
	
	[ -f ${cookiefile} ] && rm -f ${cookiefile}

	[ -z ${pass} ] && { echo "! password is blank(error may happen)."; return; }
	
	wget -q --save-cookie=${cookiefile} \
	--keep-session-cookies \
	--post-data="mail=${mail}&pass=${pass}" \
	-O /dev/null https://radiko.jp/ap/member/login/login

	[ -f "${cookiefile}" ]  || { echo -e "!! failed save cookie."; exit; }
}

getAuth1(){
	echo "*"${FUNCNAME[0]}
	argsMessage="usage: <1*:workDir> <2:auth1name>"
	leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

	[ $# -ge ${leastArgs} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 
	[ -d "$1" ] && cd $1 || { echo -e "!! \$1 not found.\nset workDir in \$1."; exit; }

	auth1=${2:-"auth1_fms"}

	[ -f ${auth1} ] && rm -f ${auth1}

	wget -q \
	--header="pragma: no-cache" \
	--header="X-Radiko-App: pc_html5" \
	--header="X-Radiko-App-Version: 0.0.1" \
	--header="X-Radiko-User: test-stream" \
	--header="X-Radiko-Device: pc" \
	--post-data='\r\n' \
	--no-check-certificate \
	--save-headers -O ${auth1} https://radiko.jp/v2/api/auth1_fms

	[ $? -eq 0 ] ||  { echo -e "!! failed auth1"; exit; }

	[ -f "${auth1}" ] && [ $(stat --printf=%s ${auth1}) -gt 1 ] || { echo -e "!! failed get auth1 (filesize=$(stat --printf=%s ${auth1}))";  }

}

getAuth2(){
	echo "*"${FUNCNAME[0]}
	argsMessage="usage: <1*:workDir> <2:cookiefile> <3:auth1> <4:auth2name>"
	leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

	[ $# -ge ${leastArgs} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 
	[ -d "$1" ] && cd $1 || { echo -e "!! \$1 not found.\nset workDir in \$1."; exit; }

	cookiefile=${2:-"cookie.txt"}
	auth1=${3:-"auth1_fms"}
	auth2=${4:-"auth2_fms"}
	AUTHKEY="bcd151073c03b352e1ef2fd66c32209da9ca0afa"

	[ -f "${auth1}" ]  || { echo -e "!! auth1(${auth1}) not found."; exit; }

	authtoken=`cat ${auth1} | tr -d "\r" | grep -i "authtoken=" | cut -d= -f2`
	offset=`cat ${auth1} | tr -d "\r" | grep -i "offset=" | cut -d= -f2`
	length=`cat ${auth1} | tr -d "\r" | grep -i "length=" | cut -d= -f2`

	partialkey=`echo ${AUTHKEY} | dd bs=1 skip=${offset} count=${length} 2> /dev/null | base64`

	[ -f ${auth2} ] && rm -f ${auth2}

	[ -f ${cookiefile} ] && auth2_url_param=$(cat ${cookiefile} | grep radiko_session | awk '$0=$NF' | sed "s;^;?radiko_session=;g")

	wget -q \
	--header="pragma: no-cache" \
	--header="X-Radiko-User: dummy_user" \
	--header="X-Radiko-Device: pc" \
	--header="X-Radiko-AuthToken: ${authtoken}" \
	--header="X-Radiko-PartialKey: ${partialkey}" \
	--post-data='\r\n' \
	-O ${auth2} https://radiko.jp/v2/api/auth2_fms${auth2_url_param}


	[ $? -eq 0 ] ||  { echo -e "!! failed auth2"; exit; }

	[ -f "${auth2}" ]  || { echo -e "!! failed get auth2"; exit; }

}

playRadiko(){
	echo "*"${FUNCNAME[0]}
	argsMessage="usage: <1*:workDir> <2*:stationID> <3:cookiefile> <4:auth1> <5:duration> <6:mpvOption>"
	leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

	[ $# -ge ${leastArgs} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 
	[ -d "$1" ] && cd $1 || { echo -e "!! \$1 not found.\nset workDir in \$1."; exit; }

	stationID=$2
	cookiefile=${3:-"cookie.txt"}
	auth1=${4:-"auth1_fms"}
	duration=${5:-"1000"}
	mpvOption=${6:-" --audio-buffer=3 --no-video --msg-level=all=warn --idle=no "}

	playLength=$((duration*60))
	mpvOption=${mpvOption}" --length="${playLength}

	timefreeFlag=0; [ -f ${cookiefile} ] && [ -z $(find ${cookiefile} -cmin -1) ] && timefreeFlag=1
	bluetoothaddr=$(hcitool con | grep -Eo "[0-9A-F:]{9,}")

	[ "$(echo $bluetoothaddr)" = "" ] || mpvOption=${mpvOption}" --audio-device=alsa/bluealsa "


	stream_url=$(curl -s https://radiko.jp/v2/station/stream_smh_multi/${stationID}.xml | grep -A2 areafree=\"${timefreeFlag}\" | grep -o http:[^\<]* | sed -n 1p)
	
	authtoken=$(cat ${auth1} | tr -d "\r" | grep -i "authtoken=" | cut -d= -f2)

	mpv ${mpvOption} --http-header-fields="X-Radiko-AuthToken: ${authtoken}" ${stream_url}

}


getRandomStationID(){
	randStation=$(curl -s https://radiko.jp/v3/station/region/full.xml |
	grep -o banner/.*/ |
	cut -d/ -f2 |
	shuf |
	head -1)
	echo ${randStation}
}

checkEnpass(){
	echo "*"${FUNCNAME[0]}
	argsMessage="usage: <1:credentialPath> <2:enpassName> <3:cipherName>"
	leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

	[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 

	credentialPath="$1"
	enpassName="${2:-"enpass"}"
	cipherName="${3:-"cipher"}"

	# if credentialPath/enpassName/cipherName not found, return function
	[ -d "${credentialPath}" ] || { echo "! credentialPath not found(${credentialPath})"; return; }
	[ -f "${credentialPath%/}/${enpassName}" ] || { echo "! enpass file not found(${enpassName})"; return; }
	[ -f "${credentialPath%/}/${cipherName}" ] || { echo "! cipher file not found(${cipherName})"; return; }

	export ENPASS=`cat ${credentialPath%/}/${enpassName}`
	pass=$(openssl enc -d -aes-256-cbc -salt -a -md sha512 -pbkdf2 -pass env:ENPASS < ${credentialPath%/}/${cipherName})

	readonly ENPASS pass

}

getStreamURL(){
	echo "*"${FUNCNAME[0]}
	argsMessage="usage: <1*:workDir> <2*:channel> <3*:fromtime> <4*:totime> <5:auth1> <6:cookie> <7:baseinput>"
	leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

	[ $# -ge ${leastArgs} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; }
	[ -d "$1" ] && cd $1 || { echo -e "!! \$1 not found.\nset workDir in \$1."; exit; }

	channel=$2
	fromtime=$3
	totime=$4
	auth1=${5:-"auth1_fms"}
	cookiefile=${6:-"cookie.txt"}
	baseinput=${7:-"baseinput.m3u8"}

	authtoken=$(cat ${auth1} | tr -d "\r" | grep -i "authtoken=" | cut -d= -f2)

	[ -z ${authtoken} ] && { echo "authtoken not found. check auth1(${auth1})"; exit 1; }

	wget  -q \
		--header="pragma: no-cache" \
		--header="Content-Type: application/x-www-form-urlencoded" \
		--header="X-Radiko-AuthToken: ${authtoken}" \
		--load-cookies $cookiefile \
		--no-check-certificate \
		-O ${baseinput} \
		"https://radiko.jp/v2/api/ts/playlist.m3u8?l=15&station_id=$channel&ft=$fromtime&to=$totime"

	[ -z $(stat --printf="%s" ${baseinput}) ] && { echo "baseinput URL not found (invalid cookie)"; exit 1; }

}


