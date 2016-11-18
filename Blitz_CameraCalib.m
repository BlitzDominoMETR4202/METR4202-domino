%This runs after running the SCC
%Team / Course: Team Blitzkrieg - METR4202
%Practical: 3
%Author: Mark Benedicto
%Date: 16 / 11 / 2016

%% %Objective:
% 1.) Get the "moving points" on the scene to get tform.
% 2.) Use IMtransform to unwarp the image.
% 3.) Extract the xdata and ydata (origin offset) of the map.

clfactor = 3;
boxImage = 'blank.png'; %Blank sheet.

try 
    distorted_sceneImage = snapshot(cam);
catch
    distorted_sceneImage = imread('sample2.png');
    %In case the camera is not connected
end


try
    sceneImage = undistortImage(distorted_sceneImage, cameraParams);
catch
    sceneImage = distorted_sceneImage; 
    %In case the camera is not calibrated
end

if first_run == 1; %From calibration script
[movingPoints, fixedPoints] = cpselect(sceneImage, boxImage, 'Wait', true);
end

length_x = 420*clfactor; %Actual length in x-direction (mm)
width_y = 280*clfactor; %Actual length in y-direction (mm)

fixedPoints = [0,0; length_x,0; length_x,width_y; 0,width_y];   
%Preset value; measured in actual workspace.

tform = cp2tform(movingPoints,fixedPoints,'projective');

[ImageCC, XDATA, YDATA] = imtransform(sceneImage,tform);

U = movingPoints(:,1);
U = U';
%Extract the x-coordinates of the fixedPoints

V = movingPoints(:,2);
V = V';
%Extract the y-coordinates of the fixedPoints

tform_movingPoints = tformfwd(tform, U, V);

I_cropped = imcrop(ImageCC, [tform_movingPoints(:,1,1)-XDATA(1)...
    tform_movingPoints(:,1,2)-YDATA(1), tform_movingPoints(:,3,1)-tform_movingPoints(:,1,1),...
    tform_movingPoints(:,3,2)-tform_movingPoints(:,1,2)]);
%Now the origin (1,1) is the top-left corner of the image.

figure;
imshow(I_cropped);
first_run = 0; %Finishing this line would mean its not the first run.