% RUN THIS FIRST, BEFORE TESTING BEGINS.

% ABOUT
% This code uses the Zhang Method to calibrate a camera.
% It determines intrinisic parameters by passing a total
% of 20 images to matlab. These images are of a checker
% board at different orientations. 

% USING - 5th Oct 2016
% When this code is run, the operate has to move the
% checker board in the workspace for 15 seconds. An output
% of accuracy and how many images at left to acquire. 

%clear all; clc;

% Initial variables

% KINECT
% cam = videoinput('kinect', 1, 'RGB_640x480');
% %cam = videoinput(1);
% cam.TriggerRepeat = 19;
% cam.FramesPerTrigger = 1;
% % % % triggerconfig(cam, 'manual');
% % % % start(cam);
% % % % for i = 1:20
% % % %     trigger(cam);
% % % %     image(:,:,:,i) = getdata(cam);
% % % %     
% % % %     if i == 3
% % % %         % Why minimum 3? MATLAB calibrates by constructing
% % % %         % homographies for each frame, these have 8 DoF.
% % % %         % There are 6 extrinstic parameters and 5 intrinstic
% % % %         % parameters. E.P vary but I.P. are constant. If
% % % %         % one I.P. is already known only 2 frames are needed.
% % % %         disp('Minimum images acquired')
% % % %     end
% % % %     
% % % %     counter = 20-i;
% % % %     disp('images_needed_to_finish_calibration');
% % % %     disp(counter);
% % % %     
% % % %     counter2 = 0.9 - exp(-i*.293);
% % % %     disp('Calibration Accuracy');
% % % %     disp(counter2);
% % % %     
% % % %     pause(0.75);
% % % % end

% WEBCAM
%cam = webcam('Microsoft LifeCam Studio');
%cam.Resolution = '1920x1080';
%cam.Resolution = '640x480';
%c1 = clock;
%c2(:,6) = 9999;
% try
%     cam = webcam(1);
% catch
%     cam = webcam(1);
% end
clear
webcamlist
num = input('Choose camera: ');
cam = webcam(num);
cam.Resolution = '1920x1080';
for i = 1:20
    imwrite(snapshot(cam), ['Image' num2str(i) '.tif']);
    
    if i == 3
         disp('Minimum images acquired for ideal case.')
    end
    
    counter = 20-i;
    disp('images_needed_to_finish_calibration');
    disp(counter);
    
    counter2 = 0.9 - exp(-i*.293);
    disp('Zhang_Butterworth Accuracy');
    disp(counter2);
    
    pause(1.25)
    
% Save the image file
end

%src = getselectedsource(cam);
%frameRates = set(src, 'FrameRate');
%src_framerate = src.FrameRate;

%save('file.mat', 'image');
% Extract the 20 images to current directory
%extraction('file.mat', image);
% Pass images to matlab's single camera calibration app.
Blitz_matlab_scc();
% Save the calibration reult
save('cameraParams.mat', 'cameraParams');

disp('Accuracy of Estimation')
disp(cameraParams.MeanReprojectionError)

focal_length_fc = mean(cameraParams.FocalLength);
cc = cameraParams.PrincipalPoint;
ccx = cc(1);
ccy = cc(2);
alpha_c = cameraParams.Skew;

%clear image;