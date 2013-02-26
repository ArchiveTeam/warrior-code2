#!/bin/bash
# This script looks for an unmounted disk where
# it can create a partition. It formats the partition
# and mounts it on /data.
#
# This is faster than rm -rf /data/ and allows the user
# to connect a new, unformatted disk to the warrior VM.

# unmount the partition
if mountpoint -q /data
then
  umount /data
fi

# find an unmounted disk
for device in /dev/disk/by-path/*
do
  device="`readlink -f "$device"`"
  if ! grep -qs "$device" /proc/mounts /proc/swaps
  then
    data_disk="$device"
    break
  fi
done

if [ -z "$data_disk" ]
then
  echo "No suitable device found for data disk"
  rm -rf /data/data
else
  # reset partition table
  echo "Creating a data partition on ${data_disk}..."
  ( echo d ; echo d ; echo d ; echo d ; echo d ; echo n ; echo p ; echo 1 ; echo ; echo ; echo w ) | fdisk $data_disk &> /dev/null

  # format drive, mount and prepare folders
  echo "Preparing the data partition..."
  mke2fs -t ext4 -O ^has_journal -E lazy_itable_init=1 ${data_disk}1 &> /dev/null
  mount -t ext4 -o noatime,nodiratime,data=writeback,barrier=0,nobh ${data_disk}1 /data
fi

mkdir /data/data
chmod 777 /data /data/data


