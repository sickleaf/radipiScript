#!/bin/bash

################################################

# DATE

BACKUPDATE=$(date +%Y%m%d)

# NAME

# script dirname in radipiScript.git (default="script") 
BASESCRIPTNAME=script

# script name in local environment 

# BACKUPDIRNAME = Script20180708

SCRIPTNAME=Script
BACKUPBASENAME=Backup
BACKUPDIRNAME=${SCRIPTNAME}${BACKUPDATE}

# USER

RADIPIUSER=radipi;


################################################

# DIR
# BASEDIR=		/home/Repository/radipiScript/${BASESCRIPTNAME}

# SCRIPTDIR=		/home/radipi/Script
# BACKUPBASEDIR=	/home/radipi/Backup
# BACKUPDIR=		/home/radipi/Backup/Script20180708

BASEDIR=$(dirname $0)/${BASESCRIPTNAME};

SCRIPTDIR=/home/${RADIPIUSER}/${SCRIPTNAME}
BACKUPBASEDIR=/home/${RADIPIUSER}/${BACKUPBASENAME}
BACKUPDIR=/home/${RADIPIUSER}/${BACKUPBASENAME}/${BACKUPDIRNAME}

# PATH

ROOTPATH=$(cd $(dirname $0); pwd);
BASEDIRFULLPATH=$(cd ${BASEDIR}; pwd);

echo "######################################";
echo "<< resetScriptDir.sh>> setup START.";
echo "######################################";

################################################
# [mkdir] BACKUPBASEDIR
################################################

mkdir -p ${BACKUPBASEDIR};
if [ $? -eq 0 ]; then
	echo "[make directory] ${BACKUPBASEDIR}";
fi


################################################
# [cp] copy SCRIPTDIR into BACKUPDIR/BACKUPSCRIPTDIR
################################################

cp -pR ${SCRIPTDIR} ${BACKUPDIR}
if [ $? -eq 0 ]; then
	echo "[copy] ${SCRIPTDIR} -> ${BACKUPDIR}";
fi


################################################
# [rm] SCRIPTDIR
################################################

rm -r ${SCRIPTDIR};
if [ $? -eq 0 ]; then
	echo "[remove directory] ${SCRIPTDIR}";
fi

echo "######################################";
echo "<< resetSetupDir.sh>> setup COMPLETE.";
echo "######################################";
