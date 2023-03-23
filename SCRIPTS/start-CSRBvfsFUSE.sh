#!/usr/bin/env bash

source $(dirname $0)/os-detect.sh
source $(dirname $0)/env.sh
. $(dirname $0)/checks.sh

NODEID=${NODEID:+,nodeID=${NODEID}}

COMMAND_TIMEOUT=${COMMAND_TIMEOUT:+,commandTimeoutMS=${COMMAND_TIMEOUT}}
COMMAND_TIMEOUT_RETRIES=${COMMAND_TIMEOUT_RETRIES:+,commandTimeoutRetries=${COMMAND_TIMEOUT_RETRIES}}

STORAGE_PATH=${STORAGE_PATH:+,storagePath=${STORAGE_PATH}}

ENABLE_MICROPYTHON=${ENABLE_MICROPYTHON:-1}
ENABLE_LAN=${ENABLE_LAN:-1}

VFS_MOUNTPOINT=${VFS_MOUNTPOINT:-/tmp/CSRBVFS}
VFS_WORKERS_COUNT=${VFS_WORKERS_COUNT:+,vfsWorkersCount=${VFS_WORKERS_COUNT}}

TRACEIO_ENABLE=${TRACEIO_ENABLE:-0}

# 32768 131072 262144 524288 1048576 2097152

MAX_READ=${MAX_READ:-1048576}
MAX_WRITE=${MAX_WRITE:-1048576}
MAX_READAHEAD=${MAX_READAHEAD:-32768}
MAX_BACKGROUND=${MAX_BACKGROUND:-1024}
CONGESTION_THRESHOLD=${CONGESTION_THRESHOLD:-8192}
WRITEBACK_CACHE=${WRITEBACK_CACHE:-0}
DIRECTIO=${DIRECTIO:-0}

if [ -n "${AUTO_CACHE}" ]
then
	AUTO_CACHE="auto_cache,"
else
	AUTO_CACHE="noauto_cache,"
fi

ENTRY_TIMEOUT=${ENTRY_TIMEOUT:-37}
ATTR_TIMEOUT=${ATTR_TIMEOUT:-${ENTRY_TIMEOUT}}
AC_ATTR_TIMEOUT=${AC_ATTR_TIMEOUT:-${ATTR_TIMEOUT}}
NEGATIVE_TIMEOUT=${NEGATIVE_TIMEOUT:-0}

BIN=${BINDIR}/CSRBvfsFUSE

while [ ! -d "${VFS_MOUNTPOINT}" ]
do
	echo "VFS_MOUNTPOINT (${VFS_MOUNTPOINT}) does not exist"
	read -p "Press ENTER to create it, or CTRL-C to abort..."
	mkdir -p "${VFS_MOUNTPOINT}"
done

${BIN} -o \
dev,\
noatime,\
allow_other,\
default_permissions,\
max_threads=256,\
max_idle_threads=256,\
${AUTO_CACHE}\
force_open_direct_io=${DIRECTIO},\
max_read=${MAX_READ},\
max_write=${MAX_WRITE},\
max_readahead=${MAX_READAHEAD},\
max_background=${MAX_BACKGROUND},\
congestion_threshold=${CONGESTION_THRESHOLD},\
entry_timeout=${ENTRY_TIMEOUT},\
attr_timeout=${ATTR_TIMEOUT},\
ac_attr_timeout=${AC_ATTR_TIMEOUT},\
negative_timeout=${NEGATIVE_TIMEOUT},\
traceio_enable=${TRACEIO_ENABLE},\
bindHost=${BIND_IP},\
bindPort=${BIND_PORT},\
networkPacingRateKBps=${NETWORK_PACING_RATE_KBPS},\
routerHost=${ROUTER_HOST},\
routerPort=${ROUTER_PORT},\
routerInterspaceUSEC=${ROUTER_INTERSPACE_USEC},\
nodeCAcertificateFile=${CA_CERT},\
nodeCertificateFile=${NODE_CERT},\
enableMicropython=${ENABLE_MICROPYTHON},\
enableLAN=${ENABLE_LAN},\
${NODEID}\
${STORAGE_PATH}\
${COMMAND_TIMEOUT}\
${COMMAND_TIMEOUT_RETRIES}\
${VFS_WORKERS_COUNT}\
 \
-f \
${VFS_MOUNTPOINT}

# -d : libfuse debug mode

