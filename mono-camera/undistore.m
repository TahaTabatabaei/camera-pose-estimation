% Load the test image
originalImage = imread("checkerboard-pr\photo_18_2023-11-13_12-56-27.jpg");

% Load camera parameters
load("camera-params", 'paramStruct');
cameraParams = cameraParameters(paramStruct);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

% show the result
figure; imshowpair(originalImage,undistortedImage,'montage');
title('Original Image (left) vs. Corrected Image (right)');

% Save undistorted Image
imwrite(undistortedImage,"undistImage.png");
