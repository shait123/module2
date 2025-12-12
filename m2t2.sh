#!/bin/bash

# Threshold in percentage
THRESHOLD=90
# Extension size
EXTEND_SIZE=1G

echo "=== Auto LV Extension Script ==="

# Get all LVs with mountpoints
lvs --noheadings -o lv_path,vg_name | while read lv vg; do
    lv=$(echo $lv | xargs)  # Trim spaces
    vg=$(echo $vg | xargs)

    mount_point=$(lsblk -no MOUNTPOINT $lv)

    # Skip if not mounted
    if [ -z "$mount_point" ]; then
        continue
    fi

    # Get disk usage percentage (drop % sign)
    usage=$(df -h $mount_point | awk 'NR==2 {print $5}' | tr -d '%')

    echo "Checking $lv mounted on $mount_point ... Usage: $usage%"

    if [ "$usage" -ge "$THRESHOLD" ]; then
        echo " $lv is above ${THRESHOLD}%. Attempting to extend..."

        # Check free space in VG
        free_space=$(vgs $vg --noheadings --units g -o vg_free | tr -dc '0-9.')

        if (( $(echo "$free_space > 1" | bc -l) )); then
            echo " VG $vg has enough space ($free_space GB free). Extending..."

            # Extend LV
            lvextend -L +$EXTEND_SIZE $lv -r

            # lvextend -r automatically grows the filesystem (EXT4 or XFS)
            echo " Successfully extended $lv by $EXTEND_SIZE"
        else
            echo " Not enough free space in VG $vg (Free: $free_space GB)"
        fi
    fi

done

echo "=== Completed ==="
