imOrig = imread("landmarks\landmark-out.jpg");
imshow(imOrig)

% Load camera parameters
load("camera-params", 'paramStruct');
cameraParams = cameraParameters(paramStruct);

imUndistorted = undistortImage(imOrig,cameraParams.Intrinsics);

% show the result
figure; imshowpair(imOrig,imUndistorted,'montage');
title('Original Image (left) vs. Corrected Image (right)');

[imagePoints,boardSize] = detectCheckerboardPoints(imUndistorted);

%camExtrinsics = estimateExtrinsics(imagePoints,worldPoints,intrinsics);

zCoord = zeros(size(worldPoints,1),1);
worldPoints = [worldPoints zCoord];

%worldStruct = toStruct(worldPoints);
save("world-struct.mat", 'worldPoints');
save("image-struct.mat", 'imagePoints');

%projectedPoints = world2img(worldPoints,camExtrinsics,intrinsics);
%hold on
%plot(projectedPoints(:,1),projectedPoints(:,2),"g*-");
%legend("Projected Points");
%hold off
