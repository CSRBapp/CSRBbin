# GITPOD QUICKSTART

## Launch
https://gitpod.io/#https://github.com/CSRBapp/CSRBbin

## System configuration
```sh
sudo apt update
sudo apt -y install fuse3
```

## Starting CSRBvfsFUSE
```sh
BINDIR=UBUNTU-18.04/ SCRIPTS/start-CSRBvfsFUSE.sh
```

## Starting CSRBnode
```sh
BINDIR=UBUNTU-18.04/ SCRIPTS/start-CSRBnode.sh
```

## ZFS Test

### System configuration
```sh
sudo apt -y install zfs-fuse
sed -i 's/^#user/user/' /etc/fuse.conf
```

### Pool Creation

#### RAID0 / STRIPED

CSRBvfsFUSE should be running

```sh
sudo zpool create -o ashift=15 -O recordsize=32k \
        -O xattr=off \
        -O atime=off \
        -O compression=off \
        -O primarycache=metadata \
        -f zCSRB \
        /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/0000000000000000000000000000000100001000 \
        /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/1000000000000000000000000000000100001000 \
        /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/2000000000000000000000000000000100001000 \
        /tmp/CSRBVFS/OBJECTBLOCK/00000000000000000000000000000000/3000000000000000000000000000000100001000
```

## pyCSRB

### Setup
```sh
$ cd DEBIAN-TESTING
$ ./decrypt.sh
> <ENTER DECRYPTION PASSWORD>
```

### Run pyCSRB Demo
```sh
$ cd pyCSRB
$ LD_LIBRARY_PATH=../DEBIAN-TESTING python3 CSRBvfsDemo.py
```

# NetBSD QUICKSTART

## Fetch
``` sh
git clone --depth 1 https://github.com/CSRBapp/CSRBbin.git
wget https://github.com/CSRBapp/CSRBbin/archive/master.zip
```

### Setup
```sh
$ cd NetBSD-9.1
$ LD_LIBRARY_PATH=SYS/ PATH=SYS/:${PATH} ./decrypt.sh
> <ENTER DECRYPTION PASSWORD>
```

### Run pyCSRB Demo
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
