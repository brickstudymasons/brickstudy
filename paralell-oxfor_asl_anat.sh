for f in $(find /home/fsluser/pcasl_festival/json_holder_1/ -type f -name '*.nii.gz') ; do
	out=pcasl_anat_output/$(basename $f)
	anat=/home/fsluser/home_holder/$(basename $f)
	mkdir $out
	oxford_asl -i $f -o $out --fslanat $anat --tis=4.5 --bolus=3.5  --casl &
done
wait
