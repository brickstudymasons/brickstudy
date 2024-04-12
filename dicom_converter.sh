find /z/MRIs -type d -iwholename '/*/*/*/*/*/*/*' -exec sh -c 'dcm2bids_helper -d
find /z/MRIs -type d -iwholename '/*/*/*/*/*/*/*/*' -exec sh -c FILE={} 'echo $FILE' +

for f in $(find /z/MRIs -type d -iwholename '/*/*/*/*/*/*/*/*') ;
do
  # make names based on $f
  out=...
  dcm2bids_helper -d $ -o /z/output/$out
done