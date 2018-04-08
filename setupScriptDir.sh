#!/bin/bash

# NAME

SCRIPTNAME=Script;
BROWSERSCRIPTNAME=browserScript;
BASESCRIPTNAME=script;
CONFIGNAME=config;

# USER

RADIPIUSER=radipi;

# DIR

BASEDIR=$(dirname $0)/${BASESCRIPTNAME};
SCRIPTDIR=/home/${RADIPIUSER}/${SCRIPTNAME}
BROWSERSCRIPTDIR=${SCRIPTDIR}/${BROWSERSCRIPTNAME}

# PATH

ROOTPATH=$(cd $(dirname $0); pwd);
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
# [mkdir] BROWSERSCRIPTDIR
#################################################

mkdir -p ${BROWSERSCRIPTDIR};
if [ $? -eq 0 ]; then
	echo "[make directory] ${BROWSERSCRIPTDIR}";
fi


################################################
# [cp]scripts in SCRIPTDIR into BROWSERSCRIPTDIR
################################################

cp ${SCRIPTDIR}/*.sh ${BROWSERSCRIPTDIR};
if [ $? -eq 0 ]; then
	echo "[copy script]${BROWSERSCRIPTDIR}/*.sh ${BROWSERSCRIPTDIR}";
fi

################################################
# [chmod]add permission(execute) into scripts in SCRIPTDIR
################################################

chmod 755 ${SCRIPTDIR}/*.sh
if [ $? -eq 0 ]; then
	echo "[chmod]${SCRIPTDIR}/*.sh set permission as 755";
fi

################################################
# [cp]copy SCRIPTDIR/config folder
################################################
cp -pR ${ROOTPATH}/${CONFIGNAME} ${SCRIPTDIR};
if [ $? -eq 0 ]; then
	echo "[copy folder]${SCRIPTDIR}/${CONFIGNAME}";
fi


echo "<< setupScriptDir.sh>> setup finished.";
