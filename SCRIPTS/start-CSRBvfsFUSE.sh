#!/usr/bin/env bash

source $(dirname $0)/common.sh

COMMAND_TIMEOUT=${COMMAND_TIMEOUT:+,commandTimeoutMS=${COMMAND_TIMEOUT}}
NODEID=${NODEID:+,nodeID=${NODEID}}
STORAGE_PATH=${STORAGE_PATH:+,storagePath=${STORAGE_PATH}}
VFS_MOUNTPOINT=${VFS_MOUNTPOINT:-/tmp/CSRBVFS}
VFS_WORKERS_COUNT=${VFS_WORKERS_COUNT:+,vfsWorkersCount=${VFS_WORKERS_COUNT}}

if [ ! -d "$VFS_MOUNTPOINT" ]
then
	echo "VFS_MOUNTPOINT ($VFS_MOUNTPOINT) does not exist"
	exit -1
fi

BIN=${BINDIR}/CSRBvfsFUSE

${BIN} -o \
nodev,\
noatime,\
allow_other,\
libfuse_max_read=1048576,\
libfuse_max_write=1048576,\
libfuse_max_readahead=0,\
libfuse_max_background=1024,\
libfuse_direct_io=0,\
force_open_direct_io=1,\
bindHost=${BIND_IP},\
bindPort=${BIND_PORT},\
networkPacingRateKBps=${NETWORKPACINGRATEKBPS},\
routerHost=${ROUTER_HOST},\
routerPort=${ROUTER_PORT},\
routerInterspaceUSEC=${ROUTER_INTERSPACE_USEC},\
nodeCAcertificateFile=${CA_CERT},\
nodeCertificateFile=${NODE_CERT},\
accessCertificateFile=${ACCESS_CERT},\
enableMicropython\
${NODEID}\
${STORAGE_PATH}\
${COMMAND_TIMEOUT}\
${VFS_WORKERS_COUNT}\
 -f ${VFS_MOUNTPOINT}

