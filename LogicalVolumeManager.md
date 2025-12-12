logical volume manager => PV , VG , LV hierarchy , extending volumes (lvextend) , reducing volumes , LVM snapshots 


Lvm allow flexible disk management : you can resize , extend , shrink , and create snapshots without downtime. 
Lvm has 3 layer structure 
physical volume(pv)-> volume group(VG) -> logical volume(LV) -> filesystem(ext4/xfs)  

Physical Volume (PV)-Actual storage devices
to create PV: pvcreate /dev/sdb1

Volume Group (VG)-A pool of storage created by combining multiple PVs.
to create VG: vgcreate myvg /dev/sdb1

Logical Volume (LV)-Created from the VG.
Works like a flexible partition.
to create LV: lvcreate -L 10G -n mylv myvg
format : mkfs.ext4 /dev/myvg/mylv
mount: /dev/myvg/mylv /mnt

status commands:
lsblk , df -h , lvdisplay , vgdisply , pvdisplay