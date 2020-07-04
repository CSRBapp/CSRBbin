#!/bin/bash

source $(dirname $0)/common.sh

COMMAND_TIMEOUT=${COMMAND_TIMEOUT:+,commandTimeoutMS=${COMMAND_TIMEOUT}}
NODEID=${NODEID:+,nodeID=${NODEID}}
STORAGE_PATH=${STORAGE_PATH:+,storagePath=${STORAGE_PATH}}
MOUNTPOINT=${MOUNTPOINT:-/mnt/CSRB}

if [ ! -x $1 ]
then
	echo "Invalid CSRBvfsFUSE file provided."
	exit 1
fi

$1 -o \
nodev,\
allow_other,\
bindHost=${BIND_IP},\
bindPort=${BIND_PORT},\
routerHost=${ROUTER_IP},\
routerPort=${ROUTER_PORT},\
nodeCAcertificateFile=${CA_CERT},\
nodeCertificateFile=${NODE_CERT}\
${NODEID}\
${STORAGE_PATH}\
${COMMAND_TIMEOUT}\
 -f ${MOUNTPOINT}

