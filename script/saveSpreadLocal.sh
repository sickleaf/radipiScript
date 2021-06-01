#!/bin/bash

getSpreadSheet(){

	argsMessage=" usage: <1*:bookID> <2:sheetID> <3:internalPath> <4:format>"
	leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

	[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}\"\n\"${argsMessage}\" "; exit; }

	bookID=$1
	sheetID=${2:-"0"}
	internalPath=$3
	format=${4:-"csv"}
	
	spreadTemp=/tmp/spread-$$
	
	dlCMD="curl -sSL "

	# if wget found and executable, change dlCMD to wget
	[ -n "$(echo $(command -v wget))" ] && [ -x "$(command -v wget)" ] && dlCMD="wget -q -T 7 -O - "


	${dlCMD} https://docs.google.com/spreadsheets/d/${bookID}/export?gid=${sheetID}\&format=${format} |
	sed -r "s/\r//" > ${spreadTemp}
	
	# if internalPath was specified, getSpreadSheet.sh will be called from other script.
	if [ "${internalPath}" = "" ]; then 
		cat ${spreadTemp}
		echo ""
	else
		mv ${spreadTemp} ${internalPath}
		echo "[spreadsheet_contents]${internalPath}"
	
	fi
	rm ${spreadTemp}

}

argsErrorHead='!!  args missing. present args=${#}, needed at least ${leastArgs} (functionName=$0})\n'
argsMessage=" usage: <1:savePath> <2:spreadList>"
leastArgs=`echo -n ${argsMessage} | sed "s;[^*];;g" | wc -m`

[ $# -ge ${leastArgs:-0} ] || { eval "echo -e \"${argsErrorHead}${argsMessage}\" "; exit; } 

scriptDir=$(cd $(dirname $0);pwd)

savePath=${1:-"/tmp/"}

[ "$2" = "" ] && spreadList=${scriptDir}/spreadList || spreadList=$2

[ -d ${savePath} ] || { echo -e "!! savePath(${savePath}) invalid."; exit; }
[ -f ${spreadList} ] || { echo -e "!! spreadList(${spreadList}) not found."; exit; }

[ $(grep -c ^ "${spreadList}") -gt 1 ] || { echo -e "!! no data in spreadList(${spreadList}). set data via makeSaveSpreadlist.sh"; exit; }

cat ${spreadList} |
sed 1d |
while read confLine; do
	bookID=$(echo ${confLine} | cut -d, -f1)
	sheetID=$(echo ${confLine} | cut -d, -f2)
	fileName=$(echo ${confLine} | cut -d, -f3)
	format=$(echo ${confLine} | cut -d, -f4)

	generateFile=${savePath%/}/${fileName}
	backupFile=${savePath%/}/"back"${fileName}

	[ -f ${generateFile} ] && [ $(stat --printf="%s" ${generateFile}) -gt 1 ] && mv -v ${generateFile} ${backupFile}

	if [ ${format} = "tsv" ]; then
		getSpreadSheet ${bookID} ${sheetID} "" ${format} |
		tr -d '\t' > ${generateFile}
		[ $? -eq 0 ] && echo "saved ${generateFile}"
	else
		getSpreadSheet ${bookID} ${sheetID} "" ${format} > ${generateFile}
		[ $? -eq 0 ] && echo "saved ${generateFile}"
	fi

	[ -f ${generateFile} ] && [ $(stat --printf="%s" ${generateFile}) -le 1 ] && mv -v ${backupFile} ${generateFile}
	[ ! -f ${generateFile} ] && mv -v ${backupFile} ${generateFile}
done
