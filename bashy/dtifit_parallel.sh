#!/bin/bash

# Base paths for files
data_path="/mnt"
output_path="/mnt/output"
mask_path="/mnt/older"
bvals_path="/mnt/older"
bvecs_path="/mnt/older"

# Loop through the numbers from 008 to 061
for i in $(seq -w 8 61); do
    data_file="$data_path/$i/eddy.nii.gz"
    mask_file="$mask_path/$i/mask.nii.gz"
    bvals_file="$bvals_path/$i/bval.bval"
    bvecs_file="$bvecs_path/$i/bvec.bvec"
    output_dir="$output_path/$i"

    # Check if all required files exist
    if [[ -f "$data_file" && -f "$mask_file" && -f "$bvals_file" && -f "$bvecs_file" ]]; then
        echo "Processing subject $i"
        mkdir -p "$output_dir" # Ensure the output directory exists
        dtifit --data="$data_file" --out="$output_dir/dtifit" --mask="$mask_file" --bvals="$bvals_file" --bvecs="$bvecs_file"
    else
        echo "Skipping subject $i: One or more required files are missing"
    fi
done
