#!/bin/bash

# NFS Health Check Script
# Checks all mounted NFS filesystems and alerts if any remote server is down

logfile="/var/log/nfs_health.log"
alert_email="admin@example.com"

echo "----- $(date) -----" >> "$logfile"

# Get list of mounted NFS servers
nfs_mounts=$(mount -t nfs,nfs4 | awk '{print $1}' | cut -d: -f1 | sort -u)

for server in $nfs_mounts; do
    # Check if server is reachable via ping
    if ping -c1 -W2 "$server" > /dev/null 2>&1; then
        echo "OK: $server reachable" >> "$logfile"
    else
        echo "ERROR: $server unreachable" >> "$logfile"
        echo "ALERT: NFS Server DOWN - $server" | mail -s "NFS ALERT: $server down" "$alert_email"
    fi
done
