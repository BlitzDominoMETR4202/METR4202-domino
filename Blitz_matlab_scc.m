%This runs after running the Zhang Calibration
%Team / Course: Team Blitzkrieg - METR4202
%Practical: 3
%Author: Will Butterworth
%Date: 16 / 11 / 2016

%% % Code

% Define images to process
imageFileNames = {'Image1.tif', 'Image2.tif', 'Image3.tif',...
    'Image4.tif', 'Image5.tif', 'Image6.tif', 'Image7.tif',...
    'Image8.tif', 'Image9.tif', 'Image10.tif', 'Image11.tif',...
    'Image12.tif', 'Image13.tif', 'Image14.tif', 'Image15.tif',...
    'Image16.tif', 'Image17.tif', 'Image18.tif', 'Image19.tif',...
    'Image20.tif',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = ...
                    detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 19.8;  % in units of 'mm'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = ...
                estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm');

% % View reprojection errors
% h1=figure; showReprojectionErrors(cameraParams, 'BarGraph');
% 
% % Visualize pattern locations
% h2=figure; showExtrinsics(cameraParams, 'CameraCentric');
% 
% % Visualise camera locations as if the pattern were stationary
% h3=figure; showExtrinsics(cameraParams, 'patternCentric');
% 
% % Display parameter estimation errors
% displayErrors(estimationErrors, cameraParams);

first_run = 1;
