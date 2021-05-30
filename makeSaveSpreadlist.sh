#!/bin/bash

tmpPath=/tmp/spreadList
dstPath=/home/radipi/Script/spreadList

cat > ${tmpPath} <<EOF
bookID,sheetID,fileName,format
EOF

echo "current spreadList"
echo 

[ -f "${dstPath}" ] && cat ${dstPath} || mv ${tmpPath} ${dstPath}

echo -e "\nhow many sheets do you want to add?(input NUMBER)"; read sheetnum


[ "$(echo $sheetnum| grep -o [0-9]*)" = "" ] && { echo "input NUMBER ONLY." ; exit; }

for i in $(seq $sheetnum);
do
	echo input bookID[line:$i]; read bookID; echo
	
	echo "input sheetID(gid)[line:$i]"; read sheetID; echo
	
	echo input fileName[line:$i]; read fileName; echo
	
	echo "is this sheet include comma?(y/n)[line:$i]"; read flag
	[ "$flag" = y ] && format=tsv || format=csv

	echo -e "\nRESULT:"
	echo "${bookID},${sheetID},${fileName},${format}" | tee -a ${dstPath}
	echo
done

echo -e "\n"setting done!"(${dstPath})"
echo
cat ${dstPath}
