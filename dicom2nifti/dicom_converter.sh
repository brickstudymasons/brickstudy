#!/usr/bin/bash

set -ex

for f in $(find /z/MRIs -type d -iwholename '/*/*/*/*/*/*/*/*')
do
  # make names based on $f
  out=/z/output/${f#"/z/MRIs/"}
  if [ ! -d "$out" ] ; then
    echo Creating new directory: $out
    mkdir -p "$out"
    dcm2bids_helper -d $f -o "$out"
  else
    echo Found existing directory: $out
  fi
done