#!/usr/bin/env bash

source $(dirname $0)/os-detect.sh
source $(dirname $0)/env.sh
. $(dirname $0)/checks.sh

NODEID=${NODEID:+,nodeID=${NODEID}}

STORAGE_PATH=${STORAGE_PATH:+,storagePath=${STORAGE_PATH}}

VFS_MOUNTPOINT=${VFS_MOUNTPOINT:-/tmp/CSRBVFS}
VFS_WORKERS_COUNT=${VFS_WORKERS_COUNT:+,vfsWorkersCount=${VFS_WORKERS_COUNT}}

COMMAND_TIMEOUT=${COMMAND_TIMEOUT:+,commandTimeoutMS=${COMMAND_TIMEOUT}}
COMMAND_TIMEOUT_RETRIES=${COMMAND_TIMEOUT_RETRIES:+,commandTimeoutRetries=${COMMAND_TIMEOUT_RETRIES}}

ATTRS_TIMEOUT=${ATTRS_TIMEOUT:-30}

TRACEIO_ENABLE=${TRACEIO_ENABLE:-0}

# NOTE: libfuse_direct_io=0 uses pages for R/W in 4k chunks
if [ -z "$NODIRECTIO" ]
then
        DIRECTIO=1
else
        DIRECTIO=0
fi

while [ ! -d "${VFS_MOUNTPOINT}" ]
do
	echo "VFS_MOUNTPOINT (${VFS_MOUNTPOINT}) does not exist"
        read -p "Press ENTER to create it, or CTRL-C to abort..."
        mkdir -p "${VFS_MOUNTPOINT}"
done

BIN=${BINDIR}/CSRBvfsFUSE

${BIN} -o \
dev,\
exec,\
noatime,\
allow_other,\
libfuse_max_read=1048576,\
libfuse_max_write=1048576,\
libfuse_max_readahead=0,\
libfuse_max_background=32,\
libfuse_attrs_timeout=${ATTRS_TIMEOUT},\
libfuse_direct_io=${DIRECTIO},\
force_open_direct_io=${DIRECTIO},\
traceio_enable=${TRACEIO_ENABLE},\
bindHost=${BIND_IP},\
bindPort=${BIND_PORT},\
networkPacingRateKBps=${NETWORK_PACING_RATE_KBPS},\
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
${COMMAND_TIMEOUT_RETRIES}\
${VFS_WORKERS_COUNT}\
 -f ${VFS_MOUNTPOINT}

