#!/usr/bin/bash

set -ex

for f in $(find /z/MRIs -type d -iwholename '/*/*/*/*/*/*/*/*')
do
  # make names based on $f
  out=/z/output/${f#"/z/MRIs/"}
  mkdir -p "$out"
  dcm2bids_helper -d $f -o "$out"
done