#!/bin/bash

# 1. Get username
username=`cmd.exe /c "echo %USERNAME%"` # Launches Windows cmd prompt and returns the username

# 2. Add MATLAB to path on local machine
program_files="Program Files"
matlab_path="C:/$program_files/MATLAB/*"
cmd.exe /c "setx /M PATH %PATH%;$matlab_path" # Uses cmd to add oldest matlab version to Windows system path
