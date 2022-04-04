#！/bin/bash
#<<global_registration >> parameter
# -f fixed_image
# -m moving_image
# -c recentered_image_pad_scr_image (if you select "rpm")
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

# registration fMOST sample target
../Dist/linux_bin/global_registration  -f target/CCF_25_u8_xpad.v3draw -c target/CCF_mask.v3draw 
-m subject/fMOST_18458_raw.v3draw  -p r+f+n -o result/fMOST/ -d 1

../Dist/linux_bin/local_registration  -p config/fMOST_config.txt -s result/fMOST/global.v3draw 
-m subject/fMOST_segmentation/ -l target/target_landmarks/low_landmarks.marker  -g target/ -o result/fMOST/


# registration LSFM sample target
../Dist/linux_bin/global_registration  -f target/CCF_25_u8_xpad.v3draw -c target/CCF_mask.v3draw 
-m subject/LSFM_raw.v3draw  -p r+f+n -o result/LSFM/ -d 70

../Dist/linux_bin/local_registration  -p config/LSFM_config.txt -s result/LSFM/global.v3draw 
-l target/target_landmarks/low_landmarks.marker  -g target/ -o result/LSFM/


# registration MRI sample target
../Dist/linux_bin/global_registration  -f target/CCF_25_u8_xpad.v3draw -c target/CCF_mask.v3draw 
-m subject/MRI_raw.v3draw  -p r+f+n -o result/MRI/ -d 20

../Dist/linux_bin/global_registration  -p config/MRI_config.txt -s result/MRI/global.v3draw 
-l target/target_landmarks/low_landmarks.marker  -g target/ -o result/MRI/


# registration VISoR sample target
../Dist/linux_bin/global_registration  -f target/CCF_25_u8_xpad.v3draw -c target/CCF_mask.v3draw 
-m subject/VISoR_raw.v3draw  -p r+f+n -o result/VISoR/ -d 20

../Dist/linux_bin/local_registration  -p config/VISoR_config.txt -s result/VISoR/global.v3draw 
-l target/target_landmarks/low_landmarks.marker  -g target/ -o result/VISoR/

pause