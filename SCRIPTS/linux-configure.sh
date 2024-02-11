#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]
then
	echo "Script needs to be run as \"root\""
	exit
fi

set -x

echo '
set bg=dark
set mouse=
' | tee /etc/vim/vimrc.local >/dev/null

apt update

apt -y install net-tools tcpdump tmux netcat strace ncdu xattr iozone3 expect iotop iftop iptraf-ng

apt -y install debootstrap fakeroot

apt -y install fuse3
sed -i "s/^#user_allow_other/user_allow_other/" /etc/fuse.conf

apt -y install zfs-fuse
service zfs-fuse --full-restart || true

