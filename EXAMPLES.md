# CSRB Examples <!-- omit in toc -->

- [CSRBfs](#csrbfs)
	- [Access Remote Node Files](#access-remote-node-files)
- [CSRBvfsFUSE](#csrbvfsfuse)
	- [Start](#start)
	- [ZFS over CSRB](#zfs-over-csrb)
		- [ZFS-FUSE limitations](#zfs-fuse-limitations)
		- [Install ZFS-FUSE](#install-zfs-fuse)
		- [ZFS-FUSE forced shutdown](#zfs-fuse-forced-shutdown)
		- [Creating a *zpool*](#creating-a-zpool)
		- [Examples](#examples)
			- [RAID-0 / STRIPED](#raid-0--striped)
			- [RAID-Z1 / RAID5](#raid-z1--raid5)
			- [Import an existing *zpool*](#import-an-existing-zpool)
- [pyCSRB](#pycsrb)
	- [Setup](#setup)
		- [Debian](#debian)
		- [NetBSD](#netbsd)
	- [Examples](#examples-1)
		- [VFS Demo](#vfs-demo)
			- [Debian](#debian-1)
			- [NetBSD](#netbsd-1)
		- [CSRB Node](#csrb-node)
			- [Debian](#debian-2)
			- [NetBSD](#netbsd-2)


# CSRBfs
The Node's local FS instance can be easily accessed locally at:\
```/tmp/CSRBVFS/FS/00000000000000000000000000000000```\
or locally and remotely at:\
```/tmp/CSRBVFS/FS/[NODEID]/```

## Access Remote Node Files
Example based on two Nodes running CSRBvfsFUSE.

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

# CSRBvfsFUSE

## Start
```sh
./SCRIPTS/start-CSRBvfsFUSE.sh
```

## ZFS over CSRB
It is not possible to use the proper OpenZFS implementaion within a Gitpod Workspace, due to the need for a kernel module and for elevated Docker privileges.

It is possible though to use the old and deprecated ZFS-FUSE implementation that is still available in the package system.

### ZFS-FUSE limitations
Due to the ZFS-FUSE being a much older ZFS implementation, the following configurations changed need to done:

* **ashift=14**: ZFS-FUSE does not seem to support a 32KB sector alignment to match the CSRB OBJECT size of 32KB. Setting *ashift* to 15 is accepted during pool creation but the internal data end up being corrupted and the pool becoming unusable.
* ~~**feature@large_dnode=enabled**~~: Not Supported
* ~~**dnodesize=auto**~~: Not Supported

### Install ZFS-FUSE
The `SCRIPTS/linux-configure.sh` script will automatically install and configure `libfuse3` and `zfs-fuse`.

Otherwise you can do this manually with:
```sh
sudo apt update

sudo apt -y install xattr fuse3
sudo sed -i "s/^#user_allow_other/user_allow_other/" /etc/fuse.conf

sudo apt -y install zfs-fuse
sudo service zfs-fuse --full-restart
```

### ZFS-FUSE forced shutdown
If things get stuck and you can't cleanly export a *zpool*, you can kill and restart ZFS-FUSE:
```sh
sudo kill -9 `pidof zfs-fuse`
sudo rm -f /var/run/zfs-fuse.pid
sudo systemctl restart zfs-fuse
```

### Creating a *zpool*
* CSRBvfsFUSE should be [running](#starting-csrbvfsfuse) before creating the ZFS Pool.
* The CSRB OBJECTBLOCK size is 32KB so *ashift* should be set to 15 (2^15).
* Need to set the ZPOOL mountpoint permissions if you want to access it as a non-root user:\
	`sudo chmod go+w /zCSRB`

### Examples

#### RAID-0 / STRIPED
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

#### RAID-Z1 / RAID5
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

#### Import an existing *zpool*
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

# pyCSRB

## Setup

### Debian
```sh
$ cd DEBIAN-TESTING
$ ./decrypt.sh
<ENTER DECRYPTION PASSWORD>
```

### NetBSD
```sh
$ cd NetBSD-x.x
$ LD_LIBRARY_PATH=SYS/ PATH=SYS/:${PATH} ./decrypt.sh
<ENTER DECRYPTION PASSWORD>
```

## Examples

### VFS Demo

#### Debian
```sh
$ cd pyCSRB
$ LD_LIBRARY_PATH=../DEBIAN-TESTING python3 CSRBvfsDemo.py
```

#### NetBSD
```sh
$ cd pyCSRB
$ LD_LIBRARY_PATH=../NetBSD-x.x/SYS:../NetBSD-x.x/ python3 CSRBvfsDemo.py
```

### CSRB Node

#### Debian
```sh
$ mkdir /tmp/CSRBSTORAGE
$ cd pyCSRB
$ python3 CSRBvfsNode.py
```

#### NetBSD
```sh
$ mkdir /tmp/CSRBSTORAGE
$ cd pyCSRB
$ LD_LIBRARY_PATH=../NetBSD-x.x/SYS:../NetBSD-x.x/ python3 CSRBvfsNode.py
```