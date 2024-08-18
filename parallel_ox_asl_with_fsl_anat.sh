for f in $(find /home/fsluser/pcasl_festival/json_holder_1/ -type f -name '*.nii.gz') ; do
	out=pcasl_anat_output/$(basename $f)good
	stripped_basename=$(basename $f)
	stripped_basename=${stripped_basename%.nii.gz}
	anat=/home/fsluser/home_holder/$stripped_basename.anat
	mkdir $out
	oxford_asl -i $f -o $out --fslanat $anat --tis=4.5 --bolus=3.5  --casl & 	
done
wait
