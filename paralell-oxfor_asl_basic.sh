for f in $(find /home/fsluser/pcasl_festival/json_holder_1/ -type f -name '*.nii.gz') ; do
	out=pcasl_festival_output/$(basename $f)
	mkdir $out
	oxford_asl -i $f -o $out --tis=4.5 --bolus=3.5  --casl &
done
wait
