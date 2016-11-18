
function count = numberDomino2(cropIm)
%This function counts the numbers of dots on an image using houghcircles.


%  figure
%  imshow(cropIm)
%  hold on

 [centersBright, radiiBright, metricBright] = imfindcircles(cropIm,[4 9], ...
     'ObjectPolarity','dark','Sensitivity',0.6,'EdgeThreshold',0.1, 'Method', 'TwoStage');

%hBright = viscircles(centersBright, radiiBright,'Color','b');

[count, unused] = size(centersBright);
if count > 5
    count = 5
elseif count == 0
    
[BW,maskedRGBImage] = createMask2(cropIm);
% imshow(maskedRGBImage);

 %figure;
 %imshow(maskedRGBImage)

 [centersBright, radiiBright, metricBright] = imfindcircles(maskedRGBImage,[6 12], ...
     'ObjectPolarity','dark','Sensitivity',0.87,'EdgeThreshold',0.1, 'Method', 'TwoStage');
%  
 % Bright = viscircles(centersBright, radiiBright,'Color','b');
 
 countBright = length(centersBright);
 
    if countBright > 3
        count = 6;
    end
 
  %hBright = viscircles(centersBright, radiiBright,'Color','b');
end
end