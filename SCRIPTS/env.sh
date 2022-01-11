BIND_IP=${BIND_IP:-0.0.0.0}
BIND_PORT=${BIND_PORT:-0}
ROUTER_HOST=${ROUTER_HOST:-public.csrb.app}
ROUTER_PORT=${ROUTER_PORT:-32450}
ROUTER_INTERSPACE_USEC=${ROUTER_INTERSPACE_USEC:-10000}
NETWORKPACINGRATEKBPS=${NETWORKPACINGRATEKBPS:-122880}

OS=`uname`
if	[[ "$OS" == "Linux" ]];		then	MD5SUM=md5sum
elif	[[ "$OS" == "OpenBSD" ]];	then	MD5SUM=md5
elif	[[ "$OS" == "FreeBSD" ]];	then	MD5SUM=md5
elif	[[ "$OS" == "NetBSD" ]];	then	MD5SUM=md5
fi

NODEID_HOSTNAME=${HOSTNAME:-`hostname -s`}
NODEID_OF_HOSTNAME=`echo -n ${NODEID_HOSTNAME} | tr -d '\n' | ${MD5SUM} | cut -d ' ' -f 1 | tr '[:lower:]' '[:upper:]'`
NODEID=$(printf "%032s" "${NODEID:-$NODEID_OF_HOSTNAME}")
NODEID=${NODEID// /0}

__SCRIPTS_DIR=$(dirname $(readlink -f $0))

CA_CERT=${CA_CERT:-${__SCRIPTS_DIR}/../CERTS/CA.nodes.csrb.crt}
NODE_CERT=${NODE_CERT:-${__SCRIPTS_DIR}/../CERTS/C9BAD58F23D5A6C095C0571512CD318D.nodes.csrb.pem}
ACCESS_CERT=${ACCESS_CERT:-${NODE_CERT}}
STORAGE_PATH=${STORAGE_PATH:-~/CSRBSTORAGE/${NODEID}/}

if [[ "$OS" == "NetBSD" ]]
then
	export LD_LIBRARY_PATH=${__SCRIPTS_DIR}/../NetBSD-9.1/SYS/
	BINDIR=${__SCRIPTS_DIR}/../NetBSD-9.1/
fi
