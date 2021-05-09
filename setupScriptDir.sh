#!/bin/bash

################################################

# NAME

# script dirname in radipiScript.git (default="script") 
BASESCRIPTNAME=script;

# script name in local environment 
# /home/${RADIPIUSER}/${SCRIPTNAME}
# /home/${RADIPIUSER}/${SCRIPTNAME}/${CONFIGNAME}

SCRIPTNAME=Script;
CONFIGNAME=config;
RADIPIUSER=$(id -u -n);

################################################

# DIR
# BASEDIR=		/home/Repository/radipiScript/${BASESCRIPTNAME}

# SCRIPTDIR=		/home/${RADIPIUSER}/${SCRIPTNAME}

BASEDIR=$(dirname $0)/${BASESCRIPTNAME};
SCRIPTDIR=/home/${RADIPIUSER}/${SCRIPTNAME}

# PATH

ROOTPATH=$(cd $(dirname $0); pwd);
SCRIPTROOTPATH=${ROOTPATH}/${BASESCRIPTNAME};

echo "######################################";
echo "<< setupScriptDir.sh>> setup START.";
echo "######################################";

echo "[make directory]";
mkdir -pv ${SCRIPTDIR};

find ${SCRIPTROOTPATH} | cut -d/ -f7- | xargs -I@ install -pvD ${SCRIPTROOTPATH}/@ ${SCRIPTDIR}/@


echo "######################################";
echo "<< setupScriptDir.sh>> setup COMPLETE.";
echo "######################################";
