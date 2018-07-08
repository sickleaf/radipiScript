#!/bin/bash

# NAME

SCRIPTNAME=Script;
BROWSERNAME=browserScript;
KEYDIRNAME=xem;

# USER

OWNGROUP=www-data;
RADIPIUSER=radipi;

# DIR

SCRIPTDIR=/home/${RADIPIUSER}/${SCRIPTNAME}/${BROWSERNAME}
KEYDIR=/home/${RADIPIUSER}/${KEYDIRNAME}


echo "######################################";
echo "<< chModOwn.sh>> setup START.";
echo "######################################";


################################################
# [chmod,chown]change scripts permission,owner user/group in SCRIPTDIR
################################################

chown root:${OWNGROUP} ${SCRIPTDIR}/*.sh
chmod 550 ${SCRIPTDIR}/*.sh
if [ $? -eq 0 ]; then
	echo "[chown,chmod] ${SCRIPTDIR}/*.sh set permission as 550, set owner/group as root/${OWNGROUP}";
fi


################################################
# [chmod,chown]change scripts permission,owner user/group in KEYDIR
################################################

chown ${RADIPIUSER}:${OWNGROUP} ${KEYDIR}/*
chmod +r ${KEYDIR}/*
if [ $? -eq 0 ]; then
	echo "[chown,chmod] ${KEYDIR}/* add +r permission, and set owner/group as ${RADIPIUSER}/${OWNGROUP}";
fi

echo "######################################";
echo "<< chModOwn.sh>> setup COMPLETE.";
echo "######################################";
