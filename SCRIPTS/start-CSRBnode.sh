#!/usr/bin/env bash

source $(dirname $0)/common.sh

if [ ! -x $1 ]
then
	echo "Invalid CSRBnode executable provided."
	exit 1
fi

$1 ${NODEID} ${BIND_IP} ${BIND_PORT} ${ROUTER_IP} ${ROUTER_PORT} ${ROUTER_INTERSPACE_USEC} ${CA_CERT} ${NODE_CERT} ${STORAGE_PATH}

