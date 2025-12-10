partition is a section of hard disk.
partitioning tools :
 fdisk - basic partitioning 
 gdisk - like fdisk for GPT
 parted - advanced tool for large disks
fdisk commands:
check disk  = fdisk -l 
open disk = fdisk /dev/sda
inside fdisk most important keys
n - create new partition
d - delete partition
p - print current table
w - write/save and exit 
q - quit without saving 

Create Filesystems
after creating a partition,need to create a filesystem, like formatting a pen drive.
Common Linux filesystems:
ext4
xfs
commands: mkfs.ext4 /dev/sda1
mkfs.xfs /dev/sda1

Mounting means malking your partition available to the system at some location
procees to mount a partition to a directory 
1. mkdir /mnt/mydata => creating a directory
2. mount /dev/sda1 /mnt/mydata => mounting the directory to partition
3. df -h => check mounted filesystems
4. umount /mnt/mydata => umount the filesystem

persistent mounts(fstab): if we mount manually , it will be lost after reboot. 
to mount automatically after every reboot -> add entry in /etc/fstab.
step1: get partition UUID => blkid /dev/sda1
step2: open fstab => nano /etc/fstab 
step3: add the entyr of partition in file
step4: test fstab => mount -a 




