# Contents <!-- omit in toc -->

- [CSRBapp](#csrbapp)
	- [Demo Videos](#demo-videos)
- [Repository Cloning](#repository-cloning)
- [Starting a CSRB application](#starting-a-csrb-application)
	- [Starting CSRBnode](#starting-csrbnode)
	- [Starting CSRBvfsFUSE](#starting-csrbvfsfuse)
	- [Configuration ENV variables](#configuration-env-variables)
- [Gitpod Guide](#gitpod-guide)
	- [Quickstart](#quickstart)
	- [Slowstart](#slowstart)
		- [Launch Workspace](#launch-workspace)
		- [Configure Workspace](#configure-workspace)
		- [Starting CSRBnode](#starting-csrbnode-1)
		- [Starting CSRBvfsFUSE](#starting-csrbvfsfuse-1)
- [Dockerisation](#dockerisation)
	- [CSRBnode Image](#csrbnode-image)
- [Examples](#examples)


# CSRBapp
This is the binary distribution of the [CSRBapp](https://csrb.app) middelware project.

## Demo Videos
* [CSRBvfs Demo Videos](https://www.youtube.com/playlist?list=PLGTW-mypw2El_xzK4qTaxEFf5KzYAOBzv) | [CSRBvfs webpage](https://csrb.app/tech/CSRBvfs.html)
* [CSRBfs Demo Videos](https://www.youtube.com/playlist?list=PLGTW-mypw2Ek5l4tW5D3hMdkhw2QFgK0p) | [CSRBfs webpage](https://csrb.app/tech/CSRBfs.html)
* [CSRB Embedded Cluster Demo Videos](https://www.youtube.com/playlist?list=PLGTW-mypw2Elqrxm2C230f2VlT9zzYOai) | [CSRBbbb webpage](https://csrb.app/tech/CSRBbbb.html)

# Repository Cloning
It is recommended that you clone a shallow repo, as the full history contains multiple binary files.
``` sh
git clone --depth 1 https://github.com/CSRBapp/CSRBbin
# or
wget https://github.com/CSRBapp/CSRBbin/archive/master.zip
```

# Starting a CSRB application
You can run one of the two provided applications, `CSRBnode` or `CSRBvfsFUSE`.
* `CSRBnode` creates a background CSRB Node instance.
* `CSRBvfsFUSE` creates a CSRB Node instance with a foreground FUSE mount to the CSRBvfs layer.

With the default settings and certificates provided, the applications will connect to a development public CSRB Network Router and provide access to the rest of the CSRB development network.

> **_NOTE_**\
You can run multiple CSRB applications at the same time, one or more instances of each, as long as set a unique NODEID, STORAGE_PATH, and VFS_MOUNTPOINT.

## Starting CSRBnode
```sh
./SCRIPTS/start-CSRBnode.sh
```

## Starting CSRBvfsFUSE
```sh
./SCRIPTS/start-CSRBvfsFUSE.sh
```

## Configuration ENV variables
| CSRB | |
| --- | --- |
| `NODEID` | Set a custom NODEID (128bit HEX). |
| `TRACEIO_ENABLE` | Enable trace prints of CSRBvfsFUSE VFS calls. |
| `ROUTER_INTERSPACE_USEC` | Software-based delay to between sending CSRB Network communication blocks (useful to throttle down UDP bursts).  |
| `NETWORK_PACING_RATE_KBPS` | Set interface / socket packet pacing rate (KBps) [if available by the OS]. |
| `COMMAND_TIMEOUT` | Timeout of each sent CSRB command (msec). |
| `COMMAND_TIMEOUT_RETRIES` | Number of retries sending a CSRB command. |
| `STORAGE_PATH` | Local directory to store the DB. |
| `ENABLE_MICROPYTHON` | Enable execution of Micropython code. |
| `ENABLE_LAN` | Enable P2P discovery and connection to other CSRB Nodes in the local network (bypasses Router for these Nodes) |
| `VFS_WORKERS_COUNT` | Number of VFS Worker threads to spawn and use. |
| **LIBFUSE** | |
| `MAX_READ` | libfuse `max_read` : Maximum size of read requests. A value of zero indicates no limit. However, even if the filesystem does not specify a limit, the maximum size of read requests will still be limited by the kernel. |
| `MAX_WRITE` | libfuse `max_write` : Maximum size of the write buffer. |
| `MAX_READAHEAD` | libfuse `max_readahead` : Maximum readahead. |
| `MAX_BACKGROUND` | libfuse `max_background` : Maximum number of pending "background" requests. A background request is any type of request for which the total number is not limited by other means. |
| `CONGESTION_THRESHOLD` | libfuse `congestion_threshold` : Kernel congestion threshold parameter. If the number of pending background requests exceeds this number, the FUSE kernel module will mark the filesystem as "congested". |
| `DIRECTIO` | libfuse `direct_io` : Disable the use of page cache (file content cache) in the kernel for this filesystem. _Forces all open() to use O_DIRECT |
| `AUTO_CACHE` | libfuse `auto_cache` : The cached data is invalidated on open(2) if if the modification time or the size of the file has changed since it was last opened. |
| `ATTR_TIMEOUT` | libfuse `attr_timeout` : The timeout in seconds for which file/directory attributes (as returned by e.g. the getattr handler) are cached. |
| `AC_ATTR_TIMEOUT` | libfuse `ac_attr_timeout_sec` : The timeout in seconds for which file attributes are cached for the purpose of checking if auto_cache should flush the file data on open.  |
| `ENTRY_TIMEOUT` | libfuse `entry_timeout` : The timeout in seconds for which name lookups will be cached. |
| `NEGATIVE_TIMEOUT` | libfuse `negative_timeout` : The timeout in seconds for which a negative lookup will be cached. This means, that if file did not exist (lookup returned ENOENT), the lookup will only be redone after the timeout, and the file/directory will be assumed to not exist until then. A value of zero means that negative lookups are not cached.  |

# Gitpod Guide
[Gitpod](https://gitpod.io) is awesome!

> [Gitpod based Demo video of CSRBfs example](https://www.youtube.com/watch?v=mE5gtfCd2ug)

> **_NOTE_**\
If connection to the CSRB Network fails then external UDP connections might be disabled by Gitpod. \
[2023/10/05]: UDP connections have been working great so far. \
[2022/02/13]: UDP connections are working again. \
[2022/01/28]: Gitpod seems to have disabled (intentionally? accidentally?) outgoing UDP connections, so for the moment you can't join the CSRB network.

## Quickstart
1. Create new Workspace: https://gitpod.io/#https://github.com/CSRBapp/CSRBbin
2. Configure system (need to rerun when Workspace is restarted): `./SCRIPTS/linux-configure.sh`
3. Tune kernel (need to rerun when Workspace is restarted): `./SCRIPTS/tune-linux.sh`
4. `./SCRIPTS/start-CSRBvfsFUSE.sh`\
or \
`TRACEIO_ENABLE=1 ./SCRIPTS/start-CSRBvfsFUSE.sh`

## Slowstart
### Launch Workspace
Open this link: https://gitpod.io/#https://github.com/CSRBapp/CSRBbin \
or \
manually create a Workspace with the CSRBbin repo (`https://github.com/CSRBapp/CSRBbin`)

### Configure Workspace
The Workspace system to be updated and configured for the CSRB applications to work properly. A set of scripts are available to automate this process, and also add some useful tools.
```sh
./SCRIPTS/linux-configure.sh
./SCRIPTS/tune-linux.sh
```

> **_NOTE_**\
If you *Stop* the Workspace, or if it *times out*, then all running applications will be stopped and the system configuration will be reset When you restart the Workspace you need to configure it again.

### Starting CSRBnode
```sh
./SCRIPTS/start-CSRBnode.sh
```

### Starting CSRBvfsFUSE
```sh
./SCRIPTS/start-CSRBvfsFUSE.sh
```

# Dockerisation
## CSRBnode Image
`ghcr.io/csrbapp/csrbnode:master`

# Examples
[CSRB Examples](EXAMPLES.md)
