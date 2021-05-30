#!/bin/bash

cd $(dirname $0)

spreadList=$(pwd)/spreadList
configPath=$(pwd)/webdir/static/config.js

[ -f "${spreadList}" ] || { echo "spreadList($spreadList). run saveSpreadLocal.sh"; exit 1; }

cat ${configPath} | grep Radipi.ch | cut -d= -f1,4- | sed "s;.$;;g" | cut -d. -f2- | tr "=" "\t"

i=1
for fl in `cat ${configPath} | grep Radipi.ch | cut -d= -f4 | sed "s;.$;;g"`;
do
	[ -f ${fl} ] && echo -e [Ch.$i] exists. || echo -e [Cn.$i] does not exists.
	i=$((i+1));
done

echo -e "\nselect which channel edit(1,2,3)"

read number

[ "$(echo $number| grep -Eo [123])" = "" ] && { echo 1,2,3 not set.try again.; exit 1; }

beforePath=$(cat ${configPath} | grep Radipi.ch | cut -d= -f4- | sed "s;.$;;g" | cut -d. -f2- | sed -n "${number}p")


echo -e "\nset new path for Ch${number}"
read afterPath

echo -e "\nbefore:${beforePath}"
echo -e " after:${afterPath}\n"

sed -i "/Radipi.ch${number}/s;${beforePath};${afterPath};g" ${configPath}
echo -e "replace done.\nRESULT"

cat ${configPath} | grep Radipi.ch | cut -d= -f1,4- | sed "s;.$;;g" | cut -d. -f2- | tr "=" "\t"

