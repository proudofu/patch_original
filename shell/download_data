#!/bin/bash
# Download finalTracks files for a given date onto a local machine from cluster.
# Argument $1 is the date of recording in YYYYMMDD format
# Argument $2 is the user's openmind username (same as Kerberos username)
# Rename folders on local machine to make room for split folders from cluster
# Copy to local machine all files from that date on cluster except for .avi files
echo "Transfer files for $1 (y/n)?"
read transfer
if [ $transfer == "y" ]; then
        mv /mnt/g/patch_data_local/$1 /mnt/g/patch_data_local/$1_unsplit
        mkdir /mnt/g/patch_data_local/$1
	for file in $2@openmind.mit.edu:/om/user/$USER/data/patch_data_cluster/$1/*; do
			# Copying over only the arguably most important files to conserve space.
			scp $file/*finalTracks* /mnt/g/patch_data_local/$1
			scp $file/*background* /mnt/g/patch_data_local/$1
			scp $file/*avi* /mnt/g/patch_data_local/$1
	done
	for file in /mnt/g/patch_data_local/$1/*; do
        	d=${file#/mnt/g/patch_data_local/$1/}
        	d="$(echo $d | cut -f 1 -d '.')"
        	if [ ! -e /mnt/g/patch_data_local/$1/$d ]; then
                	mkdir /mnt/g/patch_data_local/$1/$d
        	fi
        	mv $file /mnt/g/patch_data_local/$1/$d
	done
fi
# Launch MATLAB and run getAllCleanFinalRefeedTracks
echo "Get refeed tracks? (y/n)"
read run1
if [ $run1 == "y" ]; then
        matlab.exe -r "getRefeed('$1')"
fi
# Launch MATLAB and
echo "Check encounters? (y/n)"
read run2
if [ $run2 == "y" ]; then
        matlab.exe -r "checkEncounters('$1')"
fi
