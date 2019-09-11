#!/bin/bash
# file to format and mount disks in a linux operating system
# function to configure a disk (partition, disk format, mount)
build_disk(){
  sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $1
    n # new partition
    p # primary partition
    1 # partition number 1
      # default - first sector of disk
      # default - last sector of disk
    w # write the partition table
  EOF
  
  # partition and mount point info
  disk_path="$1"1
  mount_path=/disk$2
  # formatting the disk
  mkfs.ext3 $disk_path
  # mount the disk
  mkdir $mount_path
  mount $disk_path $mount_path

  # update the /dev/fstab file
  echo '$disk_path     $mount_path   ext3    defaults        1 2' >> /etc/fstab
}

# Following code lines are to identify the disks and send them to the build_disk() function
declare -a diskNames=("xvdc" "xvde" "xvdf" "xvdg")
num=0
# Iterate the string array using for loop
disk_list=$(lsblk -lp | grep -v 'xvda\|xvdb\|xvdh')
while read -r line; do
  for disk_name in ${diskNames[@]}; do
    if [[ $line =~ "$disk_name" ]]; then
      num=$((num+1))
      disk_path=$(echo $line | cut -f 1 -d " ")      
      build_disk $disk_path $num
    fi
  done
done <<< "$disk_list"
