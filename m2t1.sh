#!/bin/bash

# Detect the first unused disk (no partitions)
disk=$(lsblk -dpno NAME,TYPE | grep disk | awk '{print $1}' | while read d; do
    part=$(lsblk $d -no PARTTYPE | grep -v '^$')
    if [ -z "$part" ]; then
        echo $d
        break
    fi
done)

# Exit if no unformatted disk found
if [ -z "$disk" ]; then
    echo "No unformatted disk found!"
    exit 1
fi

echo "Detected new disk: $disk"

# Creating one partition using parted
parted -s $disk mklabel gpt
parted -s $disk mkpart primary xfs 0% 100%

# Identify new partition (example: /dev/sdb1)
partition="${disk}1"
echo "Created partition: $partition"

# Format partition as XFS
mkfs.xfs -f $partition

# Create mount directory based on partition name
mount_dir="/mnt/$(basename $partition)"
mkdir -p $mount_dir

# Get UUID
uuid=$(blkid -s UUID -o value $partition)

# Add entry to /etc/fstab
echo "UUID=$uuid   $mount_dir   xfs   defaults,noatime   0 0" >> /etc/fstab

# Mount all
mount -a

echo "Disk setup complete!"
echo "Mounted $partition at $mount_dir"
