# Default Socket Receive Buffer
sysctl net.core.rmem_default=262144

# Maximum Socket Receive Buffer
sysctl net.core.rmem_max=8388608

# Default Socket Send Buffer
sysctl net.core.wmem_default=262144

# Maximum Socket Send Buffer
sysctl net.core.wmem_max=8388608

# Increase the maximum amount of option memory buffers
sysctl net.core.optmem_max=402653184

# Increase the maximum total buffer-space allocatable
# This is measured in units of pages (4096 bytes)
sysctl net.ipv4.udp_mem="65536 131072 262144"

# Increase the read-buffer space allocatable
sysctl net.ipv4.udp_rmem_min=262144

# Increase the write-buffer-space allocatable
sysctl net.ipv4.udp_wmem_min=262144

