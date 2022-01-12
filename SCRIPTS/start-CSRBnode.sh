#!/usr/bin/env bash

. $(dirname $0)/checks.sh
source $(dirname $0)/env.sh

if [[ "$OS" == "NetBSD" ]]
then
	export LD_LIBRARY_PATH=${__SCRIPTS_DIR}/../NetBSD-${OS_RELEASE}/SYS/
fi

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
