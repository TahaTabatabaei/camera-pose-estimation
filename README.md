# Inside Looking-out (ILO) camera pose estimation
We try to estimate a camera pose in 3D space using photos provided by the camera 
itself. 
It is the first Mini-project of the "Computer Vision" course (University project).

- Find details in the project's report [```MV1-Tabatabei.pdf```](https://github.com/TahaTabatabaei/camera-pose-estimation/blob/main/mono-camera/MV1-Tabatabaei.pdf) about what I did and final results.
- Photos inside [```mono-camera/checkerboard-pr```](https://github.com/TahaTabatabaei/camera-pose-estimation/tree/main/mono-camera/checkerboard-pr) used to calibrate the camera.
- Directory [```mono-camera/qr/new```](https://github.com/TahaTabatabaei/camera-pose-estimation/tree/main/mono-camera/qr/new) contains qr code markers and test images. Use ```test5.jpg``` as other images might not generate valid results.
- Distances between markers in ```cords.docx``` are not accurate, consider this and measure them after printing markers or redesign the file.
- You can use ```calib.io_checker_250x350_8x7_35.pdf``` or your own checkerboard pattern, but I recommend reading the 'camera calibration' section in Methods before using other patterns.
