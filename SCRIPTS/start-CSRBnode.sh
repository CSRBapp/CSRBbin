#!/usr/bin/env bash

source $(dirname $0)/env.sh
. $(dirname $0)/checks.sh

BIN=${BINDIR}/CSRBnode

while true
do
	${BIN} ${NODEID} \
		${BIND_IP} ${BIND_PORT} \
		${ROUTER_HOST} ${ROUTER_PORT} ${ROUTER_INTERSPACE_USEC} \
		${CA_CERT} ${NODE_CERT} \
		${STORAGE_PATH}

	sleep 5
done
