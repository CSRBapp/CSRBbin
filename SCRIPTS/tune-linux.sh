#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
then
        echo "Script needs to be run as \"root\""
	exit
fi

# Increase the read-buffer space allocatable
sysctl net.core.rmem_max=335544320

# Increase the write-buffer-space allocatable
sysctl net.core.wmem_max=335544320

## Increase the maximum amount of option memory buffers
sysctl net.core.optmem_max=65536

# Increase the maximum total buffer-space allocatable
# This is measured in units of pages (4096 bytes)
sysctl net.ipv4.udp_mem="786432 1048576 1572864"

# The maximum length of the receive queue for incoming network packets on a network device
sysctl net.core.netdev_max_backlog=8192

