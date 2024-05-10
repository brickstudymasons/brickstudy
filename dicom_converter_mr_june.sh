#!/usr/bin/bash

set -ex

# here we assumed the files were 8 deep
for p in $(find /Z/previosly_missing_surfers1 -type d -name 'BRICK-020')
do
  for f in $(find $p -type d -not -name 'MR')
    do
        # make names based on $f
        out=/z/output_june/${f#"/Z/previosly_missing_surfers1"}
        if [ ! -d "$out" ] ; then
            echo Creating new directory: $out
            mkdir -p "$out"
            dcm2bids_helper -d $f -o "$out"
        else
            echo Found existing directory: $out
        fi
    done
done