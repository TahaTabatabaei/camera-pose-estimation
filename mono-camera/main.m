
% Define images to process
imageFileNames = {'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_1_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_2_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_3_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_4_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_5_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_6_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_7_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_8_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_10_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_11_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_12_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_13_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_14_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_15_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_17_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_18_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_19_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_20_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_21_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_22_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_23_2023-11-13_12-56-27.jpg',...
    'E:\taha\code\camera-calibration\mono-calibration\checkerboard-pr\photo_24_2023-11-13_12-56-27.jpg',...
    };
% Detect calibration pattern in images
detector = vision.calibration.monocular.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates for the planar pattern keypoints
squareSize = 35;  % in units of 'millimeters'
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 3, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
%h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
%displayErrors(estimationErrors, cameraParams);

oriImage = imread("qr\new\test5.jpg");

% You can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(oriImage, cameraParams);

imagePoints = barcodeFinder(undistortedImage);

worldPoints = [0 0;94 0;185 0;0 86;94 86;185 86;0 178;94 178;185 178];

zCoord = zeros(size(worldPoints,1),1);
worldPoints = [worldPoints zCoord];

% Save cameraParams
paramStruct = toStruct(cameraParams);
save("camera-params.mat", 'paramStruct');

worldPose = estworldpose(imagePoints,worldPoints,cameraParams.Intrinsics);

pcshow(worldPoints,VerticalAxis="Y",VerticalAxisDir="down", ...
    MarkerSize=40);
hold on
plotCamera(Size=10,Orientation=worldPose.R', ...
    Location=worldPose.Translation);
hold off

orileft = imread("qr\new\left.jpg");
oribottom = imread("qr\new\bottom.jpg");
oritop = imread("qr\new\top.jpg");

%cameraParams = load("camera-params.mat","paramStruct");


% You can use the calibration data to remove effects of lens distortion.
undistortedTop = undistortImage(oritop, cameraParams);
undistortedLeft = undistortImage(orileft, cameraParams);
undistortedBottom = undistortImage(oribottom, cameraParams);

topPoints = barcodeFinder(undistortedTop);
leftPoints = barcodeFinder(undistortedLeft);
bottomPoints = barcodeFinder(undistortedBottom);

worldPoints = [0 0;94 0;185 0;0 86;94 86;185 86;0 178;94 178;185 178];

zCoord = zeros(size(worldPoints,1),1);
worldPoints = [worldPoints zCoord];

worldPoseTop = estworldpose(topPoints,worldPoints,cameraParams.Intrinsics);
worldPoseLeft = estworldpose(leftPoints,worldPoints,cameraParams.Intrinsics);
worldPoseBottom = estworldpose(bottomPoints,worldPoints,cameraParams.Intrinsics);


pcshow(worldPoints,VerticalAxis="Y",VerticalAxisDir="down", ...
    MarkerSize=50);
hold on
plotCamera(Size=10,Orientation=worldPoseLeft.R', ...
    Location=worldPoseLeft.Translation, Color=[1 0 0]);
plotCamera(Size=10,Orientation=worldPoseBottom.R', ...
    Location=worldPoseBottom.Translation, Color=[0 1 0]);
plotCamera(Size=10,Orientation=worldPoseTop.R', ...
    Location=worldPoseTop.Translation, Color=[0 0 1]);
hold off



