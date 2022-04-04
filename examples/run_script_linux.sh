#！/bin/bash
#<<global_registration >> parameter
# -f fixed_image
# -m moving_image
# -c recentered_image_pad_scr_image (if you select "rpm")
# -l the x-axis padding size of the target image
# -d moving_image_threshold (if less than the given threshold,then the pixel value = 0. The default is 30)
# -p <registration_methods>，a:affine, r:rpm，f:ffd, example:a+f,r+f (It is recommended that you only need to select one option in "affine" and "rpm")
# -o the result save path

#<<local_registration >> parameter
# -p <Algorithm parameter file>, If the user uses the registration sample target, the interface needs to provide the user with four modes of registration (fMOST,LSFM,VISoR,MRI), 
#                                and the corresponding parameter file is (the file name is fixed) :fMOST_config.txt,LSFM_config.txt,VISoR_config.txt,MRI_config.txt
#                                If the user is registering with private target, we need to generate "...txt" file (see fmost_config.txt file).
# -s <global_result_image>  The file name is fixed. If the result save path is "result/", then "-s" is "result/global.v3draw".
# -m <fmost_segmentation_result> 
# -l <landmarks_file_path> example: "high_landmarks.txt" "middle_landmarks.txt" "low_landmarks.txt" 
# -o the result save path
# -u <gpu mode>,0:gpu_off,1:gpu_on

# registration fMOST sample target
../Dist/linux_bin/global_registration  -f target/25um/  -m subject/fMOST_18458_raw.nii.gz  -p r+f+n -o result/fMOST/ -d 1

../Dist/linux_bin/local_registration  -p config/fMOST_config.txt -s result/fMOST/global.nii.gz 
-m subject/fMOST_segmentation_25um/ -l target/25um/target_landmarks/low_landmarks.marker  -g target/ -o result/fMOST/


pause
