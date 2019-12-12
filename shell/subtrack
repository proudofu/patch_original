#!/bin/bash
#SBATCH --job-name=track
#SBATCH --output=/om/user/%u/log/track_%j.txt
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10000
#SBATCH --time=168:00:00

# Argument $1 should be the YYYYMMDD parent folder
# Argument $2 should be the name of the recording's subfolder, within the YYYYMMDD parent folder

module load mit/matlab/2018a
matlab -nodisplay -r "addpath(genpath('/home/$USER/patch/')), addpath(genpath('/om/user/$USER/data/patch_data_cluster')), process('$1', '$2', '$USER')"
