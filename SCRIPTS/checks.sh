#!/usr/bin/env bash

set -e

if [ ! -v BINDIR ]
then
	OS=`uname -s`
	if [[ "${OS}" == "Linux" ]]
	then
		DISTRO=`lsb_release -s -i`
		DISTRO_RELEASE=`lsb_release -s -r`
		if [[ "${DISTRO}" == "Debian" ]]
		then
			BINDIR="DEBIAN-TESTING"
		elif [[ "${DISTRO}" == "Ubuntu" ]]
		then
			if [[ "${DISTRO}" == "18.04" ]]
			then
				BINDIR="UBUNTU-18.04"
			elif [[ "${DISTRO}" == "20.04" ]]
			then
				BINDIR="UBUNTU-20.04"
			fi
		fi
	elif [[ "${OS}" == "NetBSD" ]]
	then
		OS_RELEASE=`uname -r`
		if [[ "${OS_RELEASE}" == "9.1" ]]
		then
			BINDIR="NetBSD-9.1"
		fi
	fi

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

if [ ! -d "${STORAGE_PATH}" ]
then
	echo "STORAGE_PATH [$STORAGE_PATH] does not exist"
	exit -1
fi

