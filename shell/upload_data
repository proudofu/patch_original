#!/bin/bash
# This script does the following:
# 1. Launches MATLAB on local machine so user can select ROIs of separate plates to split into separate videos
# 2. Remounts hard drive (necessary if it has been unplugged to collect data from rig manually; ideally data is
#    transferred using scp, avoiding unplugging the drive ever)
# 3. Copy data to the cluster for analysis

# Argument $1 is the date the data was recorded in YYYYMMDD format
# Argument $2 is the openmind username (same as Kerberos username) for the files to be copied to

# Get Windows username
username=`cmd.exe /c "echo %USERNAME%"` # launches Windows cmd prompt and returns the username

# 1. Select ROIs locally
PROCEED="n"
echo "Select ROIs? (y/n)"
read PROCEED
if [ $PROCEED == "y" ]; then
	matlab.exe -r "addpath(genpath('C:/Users/$username/Desktop/patch')), getROIs('$1'), quit"

	PROCEED="n"
	while [ $PROCEED != "y" ]
	do
		echo "Finished selecting fields? (y/n)"
		read PROCEED
	done
fi

# 2. Mount hard drive (assuming it was unplugged to download vids from behavior computers)
PROCEED="n"
echo "Remount? (y/n)"
read PROCEED
if [ $PROCEED == "y" ]; then
	sudo umount /mnt/g
	sudo rmdir /mnt/g
	sudo mkdir /mnt/g
	sudo mount -t drvfs G: /mnt/g
fi

# 3. Copy over folders containing video files and new fields.mat files
echo "Copying $1 to $2"
scp -r /mnt/g/patch_data_local/$1 $2@openmind.mit.edu:/om/user/$2/data/patch_data_cluster
