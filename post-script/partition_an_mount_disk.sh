# file to format and mount disks in a linux operating system
# partitioning the disk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/xvdc
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - first sector of disk
    # default - last sector of disk
  w # write the partition table
EOF

# formatting the disk
mkfs.ext3 /dev/xvdc1

# mount the disk
mkdir /disk1
mount /dev/xvdc1 /disk1

# update the /dev/fstab file
echo '/dev/xvdc1        /disk1   ext3    defaults        1 2' >> /etc/fstab

# create file in /disk1
touch /disk1/simple_file.txt
echo 'Adding a simple line in the file' >> /disk1/simple_file.txt
