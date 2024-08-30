for f in $(find /home/fsluser/pcasl_festival/json_holder_1/ -type f -name '*.nii.gz') ; do
	out=pcasl_anat_output/$(basename $f)good2
	stripped_basename=$(basename $f)
	stripped_basename=${stripped_basename%.nii.gz}
	anat=/home/fsluser/home_holder/$stripped_basename.anat
	mkdir $out
    # bolus duration not as in dicom data but as given by medical physics team
    bolusDuration='0.22170496193,0.3720622289,1.18342832912'
    # tistimes is a list of inflow times as specified by medical physics team (not DICOM)
    tistimes='1.22170496193,2.15336425781,4.5'
    # pvccorr adds partial volume correction
	oxford_asl -i $f -o $out --fslanat $anat --tis=${tistimes} --bolus=${bolusDuration}  --casl --pvcorr & 
break    	
done
wait
