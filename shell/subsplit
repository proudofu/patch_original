#!/bin/bash
#SBATCH --job-name=split
#SBATCH --output=/om/user/%u/log/split_%j.txt
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=5000
#SBATCH --time=5:00:00

# Argument $1 should be the YYYYMMDD parent folder
# Argument $2 should be the name of the recording's subfolder, within the YYYYMMDD parent folder

module load mit/matlab/2018a
matlab -nodisplay -r "addpath(genpath('/home/$USER/patch/')), splitter('$1', '$2', '$USER')"
