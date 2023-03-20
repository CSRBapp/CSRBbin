# Contents <!-- omit in toc -->

- [Repository Cloning](#repository-cloning)
- [Starting a CSRB Node application](#starting-a-csrb-node-application)
	- [Starting CSRBvfsFUSE](#starting-csrbvfsfuse)
	- [Starting CSRBnode](#starting-csrbnode)
	- [Configuration variables](#configuration-variables)
- [Demo Videos](#demo-videos)
- [CSRBfs Examples](#csrbfs-examples)
	- [Access Remote Node Files](#access-remote-node-files)
- [CSRBvfsFUSE Examples](#csrbvfsfuse-examples)
	- [ZFS Pool over CSRB](#zfs-pool-over-csrb)
		- [Create a *zpool*](#create-a-zpool)
			- [RAID0 / STRIPED](#raid0--striped)
			- [RAIDZ1 / RAID5](#raidz1--raid5)
		- [Import an existing *zpool*](#import-an-existing-zpool)
- [pyCSRB Examples](#pycsrb-examples)
	- [Setup](#setup)
	- [Run pyCSRB Demo](#run-pycsrb-demo)
- [Gitpod Guide](#gitpod-guide)
	- [Quickstart](#quickstart)
	- [Launch Workspace](#launch-workspace)
	- [Configure Workspace](#configure-workspace)
	- [Create the default STORAGE_PATH and VFS_MOUNTPOINT paths](#create-the-default-storage_path-and-vfs_mountpoint-paths)
	- [Start CSRBvfsFUSE](#start-csrbvfsfuse)
	- [Run the ZFS Pool example](#run-the-zfs-pool-example)
		- [Install ZFS-FUSE](#install-zfs-fuse)
		- [ZFS-FUSE limitations](#zfs-fuse-limitations)
		- [ZFS-FUSE forced shutdown](#zfs-fuse-forced-shutdown)
		- [Create RAID0](#create-raid0)
		- [Create RAIDZ1](#create-raidz1)
		- [Set *zCSRB* permissions](#set-zcsrb-permissions)
- [NetBSD Guide](#netbsd-guide)
	- [Setup](#setup-1)
	- [Run pyCSRB Demo](#run-pycsrb-demo-1)
	- [Run pyCSRB Node](#run-pycsrb-node)
- [Dockerisation](#dockerisation)
	- [CSRBnode Image](#csrbnode-image)
- [NOTES](#notes)


# Repository Cloning

It is recommended that you clone a shallow repo, as the full history contains multiple binary files.

``` sh
git clone --depth 1 https://github.com/CSRBapp/CSRBbin
# or
wget https://github.com/CSRBapp/CSRBbin/archive/master.zip
```


# Starting a CSRB Node application

You can run one of provided applications. With the default settings and certificates provided, they will connect to a public CSRB Network Router and provide access to the rest of the CSRB Network.

> **_NOTE_**\
You can run multiple CSRB applications at the same time, one or more instances of each, as long as you provide a unique NODEID, STORAGE_PATH, and VFS_MOUNTPOINT for each.

> **_NOTE_**\
The STORAGE_PATH and VFS_MOUNTPOINT directories need to exist for the provided scripts to run. A warning will be shown if any of the directories is found, and it will be automatically created if the user choses to proceed.

## Starting CSRBvfsFUSE
```sh
./SCRIPTS/start-CSRBvfsFUSE.sh
```
*CSRBvfsFUSE* acts as a CSRB Node and also exposes a FUSE based VFS for external applications to easily access the OBJECT, MESSAGES, etc, services of the CSRB Network.

## Starting CSRBnode
```sh
./SCRIPTS/start-CSRBnode.sh
```
*CSRBnode* acts as a passive CSRB Node without any local interactions.

## Configuration variables
* TRACEIO_ENABLE=1\
	Enable trace prints of CSRBvfsFUSE VFS calls.
* DIRECTIO=0\
	Disable by-default DirectIO access.
* ATTR_TIMEOUT=x\
	libfuse Attributes cache timeout (seconds).
* BIND_IP=x\
  Bind Router connection socket to specific IP.
* BIND_PORT=x\
  Bind Router connection socket to specific PORT.
* NETWORK_PACING_RATE_KBPS=x\
  Set interface / socket packet pacing rate (KBps) [where available].
* ROUTER_HOST=x\
  CSRB Router hostname.
* ROUTER_PORT=x\
  CSRB Router port.
* ROUTER_INTERSPACE_USEC=x\
  Try to add an (averaged) interspace delay between UDP packets sent to Router.
* COMMAND_TIMEOUT=x\
  Timeout of each sent CSRB command (msec).
* COMMAND_TIMEOUT_RETRIES=x\
  Number of retries sending a CSRB command.
* VFS_WORKERS_COUNT=x\
  Number of VFS Worker threads to spawn and use.


# Demo Videos

* [CSRBvfs Demo Videos](https://www.youtube.com/playlist?list=PLGTW-mypw2El_xzK4qTaxEFf5KzYAOBzv)
* [CSRBfs Demo Videos](https://www.youtube.com/playlist?list=PLGTW-mypw2Ek5l4tW5D3hMdkhw2QFgK0p)


# CSRBfs Examples

> [CSRBfs Webpage](https://csrb.app/tech/CSRBfs.html)

> [CSRBfs Demo Videos](https://www.youtube.com/playlist?list=PLGTW-mypw2Ek5l4tW5D3hMdkhw2QFgK0p)

The Node's local FS instance can be easily accessed locally at:\
```/tmp/CSRBVFS/FS/00000000000000000000000000000000```\
or locally and remotely at:\
```/tmp/CSRBVFS/FS/[NODEID]/```

## Access Remote Node Files
Example based on two Nodes running CSRBvfsFUSE.

> [Gitpod based Demo video](https://www.youtube.com/watch?v=mE5gtfCd2ug)

* Note down the Node IDs
```shell
nodeA$ ./SCRIPTS/host-NODEID.sh
EF7986354B959AD59AB823660C6D67B3
```
```shell
nodeB$ ./SCRIPTS/host-NODEID.sh
B2FDE721800BBC2EFAE0EA8FDC1091AF
```

* Create Local Node Files
```shell
nodeA$ echo "This file is in Node A" > /tmp/CSRBVFS/FS/00000000000000000000000000000000/TestFile.txt
```
```shell
nodeB$ echo "This file is in Node B" > /tmp/CSRBVFS/FS/00000000000000000000000000000000/TestFile.txt
```

* Access Remote Node Files
```shell
nodeA$ cat /tmp/CSRBVFS/FS/B2FDE721800BBC2EFAE0EA8FDC1091AF/TestFile.txt
This file is in Node B
```
```shell
nodeB$ cat /tmp/CSRBVFS/FS/EF7986354B959AD59AB823660C6D67B3/TestFile.txt
This file is in Node A
```


# CSRBvfsFUSE Examples

> [CSRBvfs Demo Videos](https://www.youtube.com/playlist?list=PLGTW-mypw2El_xzK4qTaxEFf5KzYAOBzv)

## ZFS Pool over CSRB
### Create a *zpool*
* CSRBvfsFUSE should be [running](#starting-csrbvfsfuse) before creating the ZFS Pool.
* The CSRB OBJECTBLOCK size is 32KB so *ashift* should be set to 15 (2^15).
* Need to set the ZFS directory permissions if you want to write to it as a user:\
	`sudo chmod go+w /zCSRB`

#### RAID0 / STRIPED
```sh
sudo zpool create -o ashift=15 -O recordsize=32k \
	-o feature@large_dnode=enabled \
	-O dnodesize=auto \
	-O xattr=sa \
	-O atime=off \
	-O compression=off \
	-O primarycache=metadata \
	-f zCSRB \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/0000000000000000000000000000000100008000 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/1000000000000000000000000000000100008000 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/2000000000000000000000000000000100008000 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/3000000000000000000000000000000100008000
```
or with *bash* you can use:
```sh
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/{0..3}000000000000000000000000000000100008000
```

#### RAIDZ1 / RAID5
```sh
sudo zpool create -o ashift=15 -O recordsize=128k \
	-o feature@large_dnode=enabled \
	-O dnodesize=auto \
	-O xattr=sa \
	-O atime=off \
	-O compression=off \
	-O primarycache=metadata \
	-f zCSRB raidz1 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/0000000000000000000000000000000100008000 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/1000000000000000000000000000000100008000 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/2000000000000000000000000000000100008000 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/3000000000000000000000000000000100008000 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/4000000000000000000000000000000100008000
```
or with *bash* you can use:
```sh
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/{0..4}000000000000000000000000000000100008000
```

### Import an existing *zpool*
```sh
sudo zpool import \
	-d /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/0000000000000000000000000000000100008000 \
	-d /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/1000000000000000000000000000000100008000 \
	-d /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/2000000000000000000000000000000100008000 \
	-d /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/3000000000000000000000000000000100008000 \
	-d /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/4000000000000000000000000000000100008000
```
or with *bash* you can use:
```sh
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/{0..4}000000000000000000000000000000100008000
```


# pyCSRB Examples

## Setup
```sh
$ cd DEBIAN-TESTING
$ ./decrypt.sh
<ENTER DECRYPTION PASSWORD>
```

## Run pyCSRB Demo
```sh
$ cd pyCSRB
$ LD_LIBRARY_PATH=../DEBIAN-TESTING python3 CSRBvfsDemo.py
```


# Gitpod Guide

> **_NOTE_**\
[2022/01/28]\
Gitpod seems to have disabled (intentionally? accidentally?) outgoing UDP connections, so for the moment you can't join the CSRB network.\
[2022/02/13]\
UDP connections are working again.

## Quickstart
1. https://gitpod.io/#https://github.com/CSRBapp/CSRBbin
2. `./SCRIPTS/linux-configure.sh`
3. `./SCRIPTS/tune-linux.sh`
4. `./SCRIPTS/start-CSRBvfsFUSE.sh`

## Launch Workspace
Open this link: https://gitpod.io/#https://github.com/CSRBapp/CSRBbin

> **_NOTE_**\
If you *Stop* the Workspace, or if it *times out*, then all running applications will be stopped and the system configuration will be reset. When you restart the Workspace you need to reconfigure/reinstall/start everything from scratch. A [script](SCRIPTS/gitpod-configure.sh) is include to reconfigure/reinstall everything.

## Configure Workspace
```sh
sudo apt update
sudo apt -y install xattr fuse3
sudo sed -i "s/^#user_allow_other/user_allow_other/" /etc/fuse.conf
```
## Create the default STORAGE_PATH and VFS_MOUNTPOINT paths
```sh
mkdir -p ~/CSRBSTORAGE/`SCRIPTS/host-NODEID.sh`
mkdir /tmp/CSRBVFS
```

## Start CSRBvfsFUSE
```sh
BINDIR=UBUNTU-20.04/ SCRIPTS/start-CSRBvfsFUSE.sh
```

## Run the [ZFS Pool](#zfs-pool-over-csrb) example
It is not possible to use the proper OpenZFS implementaion within a Gitpod Workspace, due to the need for a kernel module and for elevated Docker privileges.

It is possible though to use the old and deprecated ZFS-FUSE implementation that is still available in the package system.

### Install ZFS-FUSE
```sh
sudo apt -y install zfs-fuse
sudo service zfs-fuse --full-restart
```

### ZFS-FUSE limitations
Due to the ZFS-FUSE being a much older ZFS implementation, the following configurations changed need to done:

* **ashift=14**: ZFS-FUSE does not seem to support a 32KB sector alignment to match the CSRB OBJECT size of 32KB. Setting *ashift* to 15 is accepted during pool creation but the internal data end up being corrupted and the pool becoming unusable.
* ~~**feature@large_dnode=enabled**~~: Not Supported
* ~~**dnodesize=auto**~~: Not Supported

### ZFS-FUSE forced shutdown
If things get stuck and you can't cleanly export a *zpool*, you can kill and restart ZFS-FUSE:
```sh
sudo kill -9 `pidof zfs-fuse`
sudo rm -f /var/run/zfs-fuse.pid
sudo systemctl restart zfs-fuse
```

### Create RAID0
```sh
sudo zpool create -o ashift=14 -O recordsize=32k \
	-O xattr=off \
	-O atime=off \
	-O compression=off \
	-O primarycache=metadata \
	-f zCSRB \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/{0..3}000000000000000000000000000000100008000
```

### Create RAIDZ1
```sh
sudo zpool create -o ashift=14 -O recordsize=64k \
	-O xattr=off \
	-O atime=off \
	-O compression=off \
	-O primarycache=metadata \
	-f zCSRB raidz1 \
	/tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/{0..4}000000000000000000000000000000100008000
```

### Set *zCSRB* permissions
```sh
sudo chmod 777 /zCSRB
```

# NetBSD Guide

## Setup
```sh
$ cd NetBSD-9.1
$ LD_LIBRARY_PATH=SYS/ PATH=SYS/:${PATH} ./decrypt.sh
<ENTER DECRYPTION PASSWORD>
```

## Run pyCSRB Demo
```sh
$ cd pyCSRB
$ LD_LIBRARY_PATH=../NetBSD-9.1/SYS:../NetBSD-9.1/ python3 CSRBvfsDemo.py
```

## Run pyCSRB Node
```sh
$ mkdir /tmp/CSRBSTORAGE
$ cd pyCSRB
$ LD_LIBRARY_PATH=../NetBSD-9.1/SYS:../NetBSD-9.1/ python3 CSRBvfsNode.py
```


# Dockerisation

## CSRBnode Image
`ghcr.io/csrbapp/csrbnode:master`


# NOTES

Useful strings for copy-pasting:

```
00000000000000000000000000000000
0000000000000000000000000000000000000000
```

Helper commands:

```
sudo apt install tmux

sudo watch -n 1 zpool status zCSRB
sudo zpool iostat zCSRB -v 1
sudo zpool scrub zCSRB

dd if=/dev/urandom of=/zCSRB/fill bs=1M count=1k
```
