orileft = imread("qr\new\left.jpg");
orimid = imread("qr\new\mid.jpg");
oriright = imread("qr\new\right.jpg");

cameraParams = load("camera-params.mat","paramStruct");


% You can use the calibration data to remove effects of lens distortion.
undistortedLeft = undistortImage(orileft, cameraParams.paramStruct);
undistortedMid = undistortImage(orimid, cameraParams.paramStruct);
undistortedRight = undistortImage(oriright, cameraParams.paramStruct);

leftrPoints = barcodeFinder(undistortedLeft);
midrPoints = barcodeFinder(undistortedMid);
rightrPoints = barcodeFinder(undistortedRight);

worldPoints = [0 0;94 0;185 0;0 86;94 86;185 86;0 178;94 178;185 178];

zCoord = zeros(size(worldPoints,1),1);
worldPoints = [worldPoints zCoord];

worldPoseLeft = estworldpose(leftPoints,worldPoints,cameraParams.paramStruct.Intrinsics);
worldPoseMid = estworldpose(midPoints,worldPoints,cameraParams.paramStruct.Intrinsics);
worldPoseRight = estworldpose(rightPoints,worldPoints,cameraParams.paramStruct.Intrinsics);


pcshow(worldPoints,VerticalAxis="Y",VerticalAxisDir="down", ...
    MarkerSize=40);
hold on
plotCamera(Size=10,Orientation=worldPoseLeft.R', ...
    Location=worldPoseLeft.Translation, Color=[1 0 0]);
plotCamera(Size=10,Orientation=worldPoseMid.R', ...
    Location=worldPoseMid.Translation, Color=[0 1 0]);
plotCamera(Size=10,Orientation=worldPoseRight.R', ...
    Location=worldPoseRight.Translation, Color=[0 0 1]);
hold off

