#!/bin/bash

# NAME

SCRIPTNAME=Script;
LOCALSCRIPTNAME=localScript;

# USER

APACHEUSER=www-data;
RADIPIUSER=radipi;

# DIR

BASEDIR=$(dirname $0);
SCRIPTDIR=/home/${RADIPIUSER}/${SCRIPTNAME}
LOCALSCRIPTDIR=${SCRIPTDIR}/${LOCALSCRIPTNAME}

# PATH

BASEDIRFULLPATH=$(cd $BASEDIR; pwd);
SCRIPTLIST=`ls -ld $SCRIPTDIR/*.sh | awk '{print $NF}'`;



################################################
# [mkdir] SCRIPTDIR
################################################

#mkdir -p ${SCRIPTDIR};
#if [ $? -eq 0 ]; then
#	echo "[make directory] ${SCRIPTDIR}";
#fi
#
#
#################################################
## [cp]scripts in BASEDIR into SCRIPTDIR
#################################################
#
#BASESCRIPTLIST=`ls -ld $BASEDIRFULLPATH/*.sh | awk '{print $NF}'`;
#for EACHSCRIPT in $BASESCRIPTLIST;
#do
#	FILENAME=$(basename $EACHSCRIPT);
#	cp $EACHSCRIPT ${SCRIPTDIR}/${FILENAME};
#	if [ $? -eq 0 ]; then
#		echo "[copy]${SCRIPTDIR}/${FILENAME}";
#	fi
#done;
#
#
#################################################
# [mkdir] LOCALSCRIPTDIR
#################################################
#
#
#mkdir -p ${LOCALSCRIPTDIR};
#if [ $? -eq 0 ]; then
#	echo "[make directory] ${LOCALSCRIPTDIR}";
#fi
#
#
#################################################
## [cp]scripts in SCRIPTDIR into LOCALSCRIPTDIR
#################################################
#
#SCRIPTDIRFULLPATH=$(cd $SCRIPTDIR; pwd);
#SCRIPTLIST=`ls -ld $SCRIPTDIRFULLPATH/*.sh | awk '{print $NF}'`;
#for EACHSCRIPT in $SCRIPTLIST;
#do
#	cp ${SCRIPTDIR}/*.sh ${LOCALSCRIPTDIR};
#	if [ $? -eq 0 ]; then
#		echo "[copy script]${LOCALSCRIPTDIR}/*.sh ${LOCALSCRIPTDIR};
#	fi
#done;

################################################
# [chmod,chown]change scripts permission,owner user/group  in LOCALSCRIPTNAME
################################################

#chown root:${APACHEUSER} ${SCRIPTDIR}/*.sh
#chmod 550 ${SCRIPTDIR}/*.sh
