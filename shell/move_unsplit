#!/bin/bash

for subfolder in /om/user/$USER/data/patch_data_cluster/$1/*; do
        if [[ $(basename $subfolder) == *_refeeding_2_* ]]; then
                mv $subfolder /om/user/$USER/data/patch_data_cluster/$1_unsplit
        fi
done
