BIND_IP=${BIND_IP:-0.0.0.0}
BIND_PORT=${BIND_PORT:-0}
ROUTER_IP=${ROUTER_IP:-public.csrb.app}
ROUTER_PORT=${ROUTER_PORT:-32450}
ROUTER_INTERSPACE_USEC=${ROUTER_INTERSPACE_USEC:-0}

OS=`uname`
if      [[ "$OS" == "Linux" ]];		then	MD5SUM=md5sum
elif    [[ "$OS" == "OpenBSD" ]];	then	MD5SUM=md5
elif    [[ "$OS" == "FreeBSD" ]];	then	MD5SUM=md5
fi

NODEID_HOSTNAME=${HOSTNAME:-`hostname -s`}
NODEID_OF_HOSTNAME=`echo -n ${NODEID_HOSTNAME} | tr -d '\n' | ${MD5SUM} | cut -d ' ' -f 1 | tr '[:lower:]' '[:upper:]'`
NODEID=${NODEID:-$NODEID_OF_HOSTNAME}

__SCRIPTS_DIR=$(dirname $(readlink -f $0))

CA_CERT=${CA_CERT:-${__SCRIPTS_DIR}/../CERTS/CA.nodes.csrb.crt}
NODE_CERT=${NODE_CERT:-${__SCRIPTS_DIR}/../CERTS/C9BAD58F23D5A6C095C0571512CD318D.nodes.csrb.pem}
STORAGE_PATH=${STORAGE_PATH:-~/CSRBSTORAGE/${NODEID}/}
MOUNTPOINT=${MOUNTPOINT:-~/CSRBVFS/}

