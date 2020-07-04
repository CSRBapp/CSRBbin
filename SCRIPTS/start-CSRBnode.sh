#!/usr/bin/env bash

source $(dirname $0)/common.sh

if [ ! -x $1 ]
then
	echo "Invalid CSRBnode file provided."
	exit 1
fi

$1 ${MOUNTPOINT} ${NODEID} ${BIND_IP} ${BIND_PORT} ${ROUTER_IP} ${ROUTER_PORT} ${CA_CERT} ${NODE_CERT} ${STORAGE_PATH}

