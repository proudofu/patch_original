#!/bin/bash
# Checks which videos on a given date have finalTracks files

# Argument $1 is the date folder in YYYYMMDD format

echo
echo
echo
echo "Present finalTracks files:"
echo "----------------------------------------"

for video in /om/user/$USER/data/patch_data_cluster/$1/*; do
	if [ -e $video/*finalTracks* ]; then
		echo ${video#/om/user/$USER/data/patch_data_cluster/$1/}
	fi
done

echo
echo
echo "Missing finalTracks files:"
echo "----------------------------------------"

missing=0
for video in /om/user/$USER/data/patch_data_cluster/$1/*; do
	if [ ! -e $video/*finalTracks* ]; then
		echo ${video#/om/user/$USER/data/patch_data_cluster/$1/}
		missing=1
	fi
done
if [ $missing -eq 0 ]; then
	exit # if no missing finalTracks files, stop the script
fi
echo
echo

echo "View contents of folders with missing finalTracks files? (y/n)"
read proceed
echo
echo

if [ $proceed == "y" ]; then
for video in /om/user/$USER/data/patch_data_cluster/$1/*; do
        if [ ! -e $video/*finalTracks* ]; then
                echo ${video#/om/user/$USER/data/patch_data_cluster/$1/}:
		echo "----------------------------------------"
		ls -1 $video
		echo
		echo
        fi
done
fi
echo

echo "Reprocess folders with missing finalTracks files? (y/n)"
read repro
echo
if [ $repro == "y" ]; then
	for video in /om/user/$USER/data/patch_data_cluster/$1/*; do
		if [ -e $video/*.working ]; then
			echo "Removed ${video#/om/user/$USER/data/patch_data_cluster/$1/}.working"
			echo
			rm $video/*.working
		fi
        	if [ ! -e $video/*finalTracks* ]; then
			sbatch /home/$USER/patch/shell/subtrack $1 $(basename $video)
        	fi
	done
fi

echo
echo

