#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

# Default Socket Receive Buffer
sysctl net.core.rmem_default=262144

# Maximum Socket Receive Buffer
sysctl net.core.rmem_max=33554432

# Default Socket Send Buffer
sysctl net.core.wmem_default=262144

# Maximum Socket Send Buffer
sysctl net.core.wmem_max=33554432

# Increase the maximum amount of option memory buffers
sysctl net.core.optmem_max=268435456

# Increase the maximum total buffer-space allocatable
# This is measured in units of pages (4096 bytes)
sysctl net.ipv4.udp_mem="65536 131072 262144"

# Increase the read-buffer space allocatable
sysctl net.ipv4.udp_rmem_min=33554432

# Increase the write-buffer-space allocatable
sysctl net.ipv4.udp_wmem_min=33554432


# enable SO_MAX_PACING_RATE
tc qdisc add dev eth0 root fq limit 100000 flow_limit 10000

