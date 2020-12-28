# GITPOD QUICKSTART

## Launch
https://gitpod.io/#https://github.com/CSRBapp/CSRBbin

## Setup
```sh
$ cd DEBIAN-TESTING
$ ./decrypt.sh
> <ENTER DECRYPTION PASSWORD>
```

## Run pyCSRB Demo
```sh
$ mkdir /tmp/CSRBSTORAGE
$ cd pyCSRB
$ LD_LIBRARY_PATH=../DEBIAN-TESTING python3 CSRBvfsDemo.py
```

# NetBSD QUICKSTART

## Fetch
``` sh
git clone --depth 1 https://github.com/CSRBapp/CSRBbin.git
wget https://github.com/CSRBapp/CSRBbin/archive/master.zip
```

## Setup
```sh
$ cd NetBSD-9.1
$ LD_LIBRARY_PATH=SYS/ PATH=SYS/:${PATH} ./decrypt.sh
> <ENTER DECRYPTION PASSWORD>
```

## pyCSRB Configuration ENV Variables
* ROUTERHOST
* STORAGEPATH

## Run pyCSRB Demo
```sh
$ mkdir /tmp/CSRBSTORAGE
$ cd pyCSRB
$ LD_LIBRARY_PATH=../NetBSD-9.1/SYS:../NetBSD-9.1/ python3 CSRBvfsDemo.py
```

## Run pyCSRB Node
```sh
$ mkdir /tmp/CSRBSTORAGE
$ cd pyCSRB
$ LD_LIBRARY_PATH=../NetBSD-9.1/SYS:../NetBSD-9.1/ python3 CSRBvfsNode.py
```
