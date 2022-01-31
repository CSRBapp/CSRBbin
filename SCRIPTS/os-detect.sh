SCRIPTS_DIR=$(dirname $(readlink -f $0))

if [ ! -v BINDIR ]
then
	OS=`uname -s`
	case "${OS}" in
		Linux)
			DISTRO=`lsb_release -s -i`
			DISTRO_RELEASE=`lsb_release -s -r`
			case "${DISTRO}" in
				Debian)
					BINDIR="DEBIAN-TESTING"
					;;
				Ubuntu)
					case "${DISTRO_RELEASE}" in
						18.04)
							BINDIR="UBUNTU-18.04"
							;;
						20.04)
							BINDIR="UBUNTU-20.04"
							;;
					esac
					;;
			esac
			;;
		NetBSD)
			OS_RELEASE=`uname -r`
			case ${OS_RELEASE} in
				9.1)
					BINDIR="NetBSD-9.1"
					LD_LIBRARY_PATH=${SCRIPTS_DIR}/../NetBSD-${OS_RELEASE}/SYS/
					;;
			esac
			;;
		OpenBSD)
			OS_RELEASE=`uname -r`
			case ${OS_RELEASE} in
				7.9)
					BINDIR="OpenBSD-7.0"
					;;
			esac
			;;
	esac

	if [ -v BINDIR ]
	then
		echo "BINDIR AUTODETECTED TO: ${BINDIR}"
	fi
fi

if [ ! -v BINDIR ]
then
	echo "BINDIR not set and cannot be AUTODETECTED"
	exit -1
fi

export OS
export OS_RELEASE
export DISTRO
export DISTRO_RELEASE
export BINDIR
export LD_LIBRARY_PATH

