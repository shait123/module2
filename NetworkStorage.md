NFS - network file system 
a network protocol for distributed file system.
using this , a user on the client computer can access the files on server side like as they are accessing locally. 

to install nfs packages :
yum install nfs-utils libnfsidmap -y

enable and start the NFS services :
systemctl enable rpcbind, nfs-server
systemctl start rpcbind, nfs-server, rpc-statd,nfs-idmap

ServerSide configuration :
create a directory for NFS and give all the permissions - mkdir /server/apps
modify the /etc/exports file and add new shared filesystem - /apps <IP_allow>(rw, sync, no_root_squash)
apply export changes - exportfs -rv
Check exported directories
showmount -e <server-ip>

ClientSide configuration:
Clients mount the remote NFS directory into their local filesystem.
to install nfs package- yum install nfs-utils rpcbind 
enable and start the rpcbind service- systemctl enable rpcbind
Check available NFS exports- showmount -e <server-ip>

AUTOMOUNTER (Autofs) - on demand nfs mounting 
Autofs automatically mounts NFS only when accessed
install autofs - yum install autofs -y
edit /etc/auto.master 
create /etc/auto.nfs
start autofs - sudo systemctl enable --now autofs
test autofs - ls /nfs/share
as soon as we access it -> autofs mount nfs automatically 
check mount- mount | grep nfs