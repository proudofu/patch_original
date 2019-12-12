#!/bin/bash

# Distributed splitting
mkdir /om/user/$USER/data/patch_data_cluster/$1_unsplit
for subfolder in /om/user/$USER/data/patch_data_cluster/$1/*; do
	sbatch /home/$USER/patch/shell/subsplit $1 $(basename $subfolder)
done
sleep 5h # Splitting takes approximately this long. There's certainly a better way to do this
	 # without hard-coding, but I haven't invested the time!

# Move unsplit videos to unsplit folder
for subfolder in /om/user/$USER/data/patch_data_cluster/$1/*; do
	if [[ $(basename $subfolder) == *_refeeding_2_* ]]; then
		mv $subfolder /om/user/$USER/data/patch_data_cluster/$1_unsplit
	fi
done
