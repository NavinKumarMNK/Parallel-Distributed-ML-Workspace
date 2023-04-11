#!/bin/bash

# Define the NFS server and mount point
server="172.16.96.66"
mount_point="/mnt/nfs_share"

# Install the NFS client package
echo "win@123" | sudo -S apt-get -y update
echo "win@123" | sudo -S apt-get install -y nfs-common
# Create the mount point directory
echo "win@123" | sudo -S mkdir $mount_point
# Mount the NFS share
echo "sudo mount -t nfs $server:/mnt/nfs_share $mount_point" >> ~/.bashrc
echo "export PATH=/usr/local/cuda-11.7/bin${PATH:+:${PATH}}" >> ~/.bashrc
echo "LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64\ {LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc 
source ~/.bashrc
