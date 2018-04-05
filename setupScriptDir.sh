#!/bin/bash

# NAME

SCRIPTNAME=Script;
LOCALSCRIPTNAME=localScript;
BASESCRIPTNAME=script;

# USER

RADIPIUSER=radipi;

# DIR

BASEDIR=$(dirname $0)/${BASESCRIPTNAME};
SCRIPTDIR=/home/${RADIPIUSER}/${SCRIPTNAME}
LOCALSCRIPTDIR=${SCRIPTDIR}/${LOCALSCRIPTNAME}

# PATH

BASEDIRFULLPATH=$(cd $BASEDIR; pwd);


################################################
# [mkdir] SCRIPTDIR
################################################

mkdir -p ${SCRIPTDIR};
if [ $? -eq 0 ]; then
	echo "[make directory] ${SCRIPTDIR}";
fi

################################################
# [cp]scripts in BASEDIR into SCRIPTDIR
################################################

BASESCRIPTLIST=`ls -ld $BASEDIRFULLPATH/*.sh | awk '{print $NF}'`;
for EACHSCRIPT in $BASESCRIPTLIST;
do
	FILENAME=$(basename $EACHSCRIPT);
	cp $EACHSCRIPT ${SCRIPTDIR}/${FILENAME};
	if [ $? -eq 0 ]; then
		echo "[copy]${SCRIPTDIR}/${FILENAME}";
	fi
done;

#################################################
# [mkdir] LOCALSCRIPTDIR
#################################################

mkdir -p ${LOCALSCRIPTDIR};
if [ $? -eq 0 ]; then
	echo "[make directory] ${LOCALSCRIPTDIR}";
fi


################################################
# [cp]scripts in SCRIPTDIR into LOCALSCRIPTDIR
################################################

cp ${SCRIPTDIR}/*.sh ${LOCALSCRIPTDIR};
if [ $? -eq 0 ]; then
	echo "[copy script]${LOCALSCRIPTDIR}/*.sh ${LOCALSCRIPTDIR}";
fi

################################################
# [chmod]change scripts permission in LOCALSCRIPTDIR
################################################

chmod 755 ${LOCALSCRIPTDIR}/*.sh
if [ $? -eq 0 ]; then
	echo "[chmod]${LOCALSCRIPTDIR}/*.sh set permission as 755";
fi


echo "<< setupScriptDir.sh>> setup finished.";
