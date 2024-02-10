#!/bin/bash

# settings for gitpod
CSRBBIN=/workspace/CSRBbin
STORAGE=/workspace

PANE_RUN=0:0.1

NODE=00000000000000000000000000000000
CSRBVFS=/tmp/CSRBVFS
TARGETDIR=jammy
USE_TMPFS=1

###

fRUNDEBOOTSTRAP() {
touch /tmp/demo-debootstrap-running

tmux send-keys -t "${PANE_RUN}" "
cd /tmp

bash -evc \"
trap 'exit' SIGINT

# wait for CSRBvfsFUSE to start
while [ ! -f ${CSRBVFS}/.creation_ownerdigest ]; do sleep 1s ; done

cd ${CSRBVFS}/FS/${NODE}/
mkdir ${TARGETDIR}
cd ${TARGETDIR}
mkdir slash

mkdir slash/debootstrap
mount -t tmpfs none slash/debootstrap

#mkdir slash/dev
#mount --rbind /dev /dev

# create tmpfs scripts

mkdir -m777 -p slash/tmp
mkdir -m777 -p slash/var/tmp
mkdir -p slash/var/lib/apt/lists
mkdir -p slash/var/cache/apt/archives

echo \\\"
#!/bin/sh

mount -t tmpfs none tmp
mount -t tmpfs none var/tmp
mount -t tmpfs none var/lib/apt/lists
mount -t tmpfs none var/cache/apt/archives
\\\" >> slash/mount-tmpfs.sh

echo \\\"
#!/bin/sh

umount tmp
umount var/tmp
umount var/lib/apt/lists
umount var/cache/apt/archives
\\\" >> slash/umount-tmpfs.sh

# mount tmpfs
if [ \\\"${USE_TMPFS}\\\" == \\\"1\\\" ]
then
	(cd slash ; bash mount-tmpfs.sh)
fi

# install CSRBfsTweaks
pushd ${CSRBBIN}/CSRBfsTweaks/
make rebuild
./install.sh ${CSRBVFS}/FS/${NODE}/${TARGETDIR}/slash/CSRBfsTweaks
mkdir ${CSRBVFS}/FS/${NODE}/${TARGETDIR}/slash/etc/
echo /CSRBfsTweaks/CSRBfsTweaks.so > ${CSRBVFS}/FS/${NODE}/${TARGETDIR}/slash/etc/ld.so.preload
popd

# install system
mkdir ${STORAGE}/debootstrap-ubuntu-cache || true
touch slash/debootstrap/debootstrap.log
time fakeroot debootstrap --cache-dir=${STORAGE}/debootstrap-ubuntu-cache --no-check-gpg --variant=minbase jammy slash http://archive.ubuntu.com/ubuntu || true

# we can detect a clean debootstrap completion by the lack of a log
if [ ! -f slash/debootstrap/debootstrap.log ]
then
	rm -f /tmp/demo-debootstrap-running
else
	echo \\\"DEBOOTSTRAP FAILED\\\"
fi
\"
"
}

fRUNDEBSUMS() {
rm -f /tmp/demo-debsums-error
touch /tmp/demo-debsums-running

tmux send-keys -t "${PANE_RUN}" "
bash -evc \"

cd ${CSRBVFS}/FS/${NODE}/${TARGETDIR}

# configure system
echo \\\"deb http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse\\\" > slash/etc/apt/sources.list
echo \\\"deb-src http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse\\\" >> slash/etc/apt/sources.list
echo 2175d9b2344a499abd87920c6f76f9a1 > slash/etc/machine-id
echo \\\"nameserver 1.1.1.1\\\" > slash/etc/resolv.conf

# install debsums
chroot slash bash -c \\\"
apt update
DEBIAN_FRONTEND=noninteractive apt install -y locales debsums
locale-gen en_GB.UTF-8
\\\"

# run debsums
time chroot slash debsums -c || touch /tmp/demo-debsums-error

# finish gracefully
rm -f /tmp/demo-debsums-running
\"
"
}

fEXTRA() {
rm -f /tmp/demo-extra-error
touch /tmp/demo-extra-running

tmux send-keys -t "${PANE_RUN}" "
bash -evc \"

cd ${CSRBVFS}/FS/${NODE}/${TARGETDIR}

chroot slash bash -evc \\\"
apt update
DEBIAN_FRONTEND=noninteractive apt install -y build-essential fakeroot devscripts
DEBIAN_FRONTEND=noninteractive apt build-dep -y gcc-defaults

mkdir gcc ; cd gcc

DEBIAN_FRONTEND=noninteractive apt source gcc-defaults

echo \\\\\\\$(ls -d */)
cd \\\\\\\$(ls -d */)
time debuild -us -uc -i -I
\\\"
\" || touch /tmp/demo-extra-error

# finish gracefully
rm -f /tmp/demo-extra-running

"
}

set -e

echo -n "DEBOOTSTRAP started at: " ; date
fRUNDEBOOTSTRAP
while [ -f /tmp/demo-debootstrap-running ]; do sleep 1s ; done
echo -n "DEBOOTSTRAP finished at: " ; date

echo -n "DEBSUMS started at: " ; date
fRUNDEBSUMS
while [ -f /tmp/demo-debsums-running ]; do sleep 1s ; done
echo -n "DEBSUMS finished at: " ; date

if [ -f /tmp/demo-debsums-error ]
then
	echo "FAILURE DETECTED"
fi

echo -n "EXTRA started at: " ; date
fEXTRA
while [ -f /tmp/demo-extra-running ]; do sleep 1s ; done
echo -n "EXTRA finished at: " ; date

if [ -f /tmp/demo-extra-error ]
then
	echo "FAILURE DETECTED"
fi

