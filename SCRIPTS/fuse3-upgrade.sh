#!/bin/bash

set -e

FUSE_VERSION=3.16.2

# remove existing fuse3
apt purge -y fuse3 libfuse3-3

# install fuse3 compile tools and dependencies
apt install -y cmake meson udev libudev-dev

# download fuse3
wget -P /tmp/ https://github.com/libfuse/libfuse/releases/download/fuse-${FUSE_VERSION}/fuse-${FUSE_VERSION}.tar.gz

# extract, compile, and install

tar -C /tmp -pzxf /tmp/fuse-${FUSE_VERSION}.tar.gz

mkdir /tmp/fuse-${FUSE_VERSION}/build
cd /tmp/fuse-${FUSE_VERSION}/build
meson setup -Dprefix=/usr ../
ninja
ninja install

# set again fuse configuration
sed -i "s/^#user_allow_other/user_allow_other/" /etc/fuse.conf

# show what we installed
ls -l /lib/x86_64-linux-gnu/libfuse3.so.3

