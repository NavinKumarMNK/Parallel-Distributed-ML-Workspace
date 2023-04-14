# Contents of nfs bash file

This script automates the process of installing the NFS client package, creating a mount point directory, and mounting an NFS share on a Linux system.

The first two lines of the script update the package list and install the nfs-common package, which is required for mounting an NFS share.
```
# Install the NFS client package
echo "win@123" | sudo -S apt-get -y update
echo "win@123" | sudo -S apt-get install -y nfs-common
```

The next line defines the NFS server's IP address as <b><i>172.16.96.66</b></i> and the mount point as <b><i>/mnt/nfs_share</b></i>.
```
# Create the mount point directory
echo "win@123" | sudo -S mkdir $mount_point
```

The subsequent three lines create the mount point directory, and then append the mount command to the ~/.bashrc file to mount the NFS share automatically on system startup.
```
# Mount the NFS share
echo "sudo mount -t nfs $server:/mnt/nfs_share $mount_point" >> ~/.bashrc
```

Finally, the source command is used to reload the updated ~/.bashrc file, which applies the changes to the system.
```
source ~/.bashrc
```