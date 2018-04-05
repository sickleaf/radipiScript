#!/bin/bash

# NAME

SCRIPTNAME=Script;

# USER

OWNGROUP=www-data;
RADIPIUSER=radipi;

# DIR

SCRIPTDIR=/home/${RADIPIUSER}/${SCRIPTNAME}

################################################
# [chmod,chown]change scripts permission,owner user/group in SCRIPTDIR
################################################

chown root:${OWNGROUP} ${SCRIPTDIR}/*.sh
chmod 550 ${SCRIPTDIR}/*.sh
if [ $? -eq 0 ]; then
	echo "[chown,chmod]${SCRIPTDIR}/*.sh set permission as 550, set owner/group as root/${OWNGROUP}";
fi


