
function Domino = DominoData(A)
%This is the function, that returns all data about the dominos on the
%screen. It is important, that the image that is fed into this function is
%undistorted and that x and y axis are aligned with the x and y axis in
%reality

clfactor = 3; 

%suppress warnings to avoid confusion and speed up code
%hough circles warning: accurcay low
id = 'images:imfindcircles:warnForSmallRadius';
warning('off',id);
%image displayed is not 100% of the size
id = 'images:initSize:adjustingMag';
warning('off',id);




%% RECOGNISE DOMINOES WITH MSER FEATURES. REMOVE DOUBLE DETECTIONS 


B = rgb2gray(A);
[regions] = detectMSERFeatures(B, 'ThresholdDelta', 2, 'RegionAreaRange', [400,500], 'MaxAreaVariation', 0.062 );
%originally 150,400 maxareavariation 0.05 orig
%figure; imshow(B); hold on;
%plot(regions,'showPixelList',true,'showEllipses',true);

%get rid of ellipses that show the same domino



%define start variables
limit = regions.Count;
n = 1;

% remove double detections because MSER is going to
%detect the same feature multiple times
while n < limit
    m = n+1;
    while m < (limit+1)
        distance = abs(regions(n).Location - regions(m).Location);
        if distance(1)<17 && distance(2)<17
            regions(m) = [];
            limit = limit - 1;
        end
        m = m+1;
    end
    n = n+1;
end

limit = regions.Count;
n = 1;
while n <= limit
    checkTest = regions(n).Axes;
    checkdivider = checkTest(1,1)/checkTest(1,2)
    if checkdivider < 4.5
        regions(n) = [];
        limit = limit - 1;
    end
    n=n+1
end

figure; imshow(B); hold on;
plot(regions,'showPixelList',true,'showEllipses',true);

%Copy regions into new array that I can work with. detail by detail. 
Domino.Count = regions.Count;
for n = 1:regions.Count
    Domino(n).Location = regions(n).Location;
    Domino(n).Axes = regions(n).Axes;
    Domino(n).Orientation = regions(n).Orientation;
    %Domino(n).PixelList = regions(n).PixelList;
end
  

%% GET CROPPED IMAGES OF HALF OF THE DOMINOES AND THEN READ IT

%for every domino:
%extract value and calculate hough space line for the centre bar
%----------make sure that the angle is correct. 
for n = 1:regions.Count
    %% ADJUST AND CONVERT THE ANGLES --> MSER ANGLE TO HOUGH REPRESENTATION
    
    %transform the angle provided by MSER to the perpendicular angles that
    %Hough uses
    if Domino(n).Orientation > 0
        ThetaRad = -(Domino(n).Orientation - (pi/2));
    elseif Domino(n).Orientation < 0
        ThetaRad = - (Domino(n).Orientation + (pi/2));
    else 
        ThetaRad = pi/2
    end
    
    %Replace the Orientation of the domino with the orientation required by
    %the movement code (facing upwards means 0deg, rotation is in the
    %mathematical way - clockwise negative)
    if ThetaRad > 0
        Domino(n).Orientation = -(rad2deg(ThetaRad) - 90); 
    elseif ThetaRad < 0
        Domino(n).Orientation = -(rad2deg(ThetaRad) + 90); 
    else 
        Domino(n).Orientation = 90; 
    end
    
    %% GET ALL OUTLINES AND THE SEPERATING LINE IN THE MIDDLE
    
    
    %Define the axis in hough coordinates of the middle line at the domino
    x = Domino(n).Location(1);
    y = Domino(n).Location(2);
    Domino(n).Middle = [ ThetaRad , x*cos(ThetaRad) + y*sin(ThetaRad)];


    
    %get 4 outlines as hough lines
    %----------make sure rotation of the angles are correct ( within the
    %limits 
    LongRatio = 1.25*Domino(n).Axes(1);
    ShortRatio = 0.625*Domino(n).Axes(1);
    LongAngle = Domino(n).Middle(1);
    
    %Short angle is perpendicular and must be transformed in the same way
    %as previously but no inversion!!
    if LongAngle > 0
        ShortAngle = LongAngle - (pi/2);
    elseif LongAngle < 0
        ShortAngle = LongAngle + (pi/2);
    else 
        ShortAngle = pi/2;
    end
    
    %For short Hough Rho values must be calculated. start be getting the
    %rho value through the centroid. then short ratio is added/ subtracted
    
    RhoMiddle = x*cos(ShortAngle) + y*sin(ShortAngle);
    Domino(n).Long = [ LongAngle, Domino(n).Middle(2) + LongRatio ; LongAngle , Domino(n).Middle(2) - LongRatio];
    Domino(n).Short = [ ShortAngle, RhoMiddle + ShortRatio ; ShortAngle , RhoMiddle - ShortRatio];

  
    %% MASK THE IMAGES WITH THE CREATED OUTLINES IN ONE SUBIMAGE FOR EACH NUMBER


      %get First Crop
     cornerPoints(1,:) =  Domino(n).Middle;
     cornerPoints(2,:) =  Domino(n).Long(1,:);

     cornerPoints(3,:) =  Domino(n).Short(1,:);
     cornerPoints(4,:) =  Domino(n).Short(2,:);

     M = [cos(cornerPoints(1,1)), sin(cornerPoints(1,1)); cos(cornerPoints(3,1)), sin(cornerPoints(3,1))];
     b = [ cornerPoints(1,2), cornerPoints(3,2)];

     cornerPointsXY1(1,:) =  M\(b.');

     M = [cos(cornerPoints(1,1)), sin(cornerPoints(1,1)); cos(cornerPoints(4,1)), sin(cornerPoints(4,1))];
     b = [ cornerPoints(1,2), cornerPoints(4,2)];

     cornerPointsXY1(2,:) =  M\(b.'); 

     M = [cos(cornerPoints(2,1)), sin(cornerPoints(2,1)); cos(cornerPoints(3,1)), sin(cornerPoints(3,1))];
     b = [ cornerPoints(2,2), cornerPoints(3,2)];

     cornerPointsXY1(3,:) =  M\(b.'); 

     M = [cos(cornerPoints(2,1)), sin(cornerPoints(2,1)); cos(cornerPoints(4,1)), sin(cornerPoints(4,1))];
     b = [ cornerPoints(2,2), cornerPoints(4,2)];

     cornerPointsXY1(4,:) =  M\(b.');



     %get second Crop 
     cornerPoints(1,:) =  Domino(n).Long(2,:);
     cornerPoints(2,:) =  Domino(n).Middle;

     cornerPoints(3,:) =  Domino(n).Short(1,:);
     cornerPoints(4,:) =  Domino(n).Short(2,:);

     M = [cos(cornerPoints(1,1)), sin(cornerPoints(1,1)); cos(cornerPoints(3,1)), sin(cornerPoints(3,1))];
     b = [ cornerPoints(1,2), cornerPoints(3,2)];

     cornerPointsXY2(1,:) =  M\(b.');

     M = [cos(cornerPoints(1,1)), sin(cornerPoints(1,1)); cos(cornerPoints(4,1)), sin(cornerPoints(4,1))];
     b = [ cornerPoints(1,2), cornerPoints(4,2)];

     cornerPointsXY2(2,:) =  M\(b.'); 

     M = [cos(cornerPoints(2,1)), sin(cornerPoints(2,1)); cos(cornerPoints(3,1)), sin(cornerPoints(3,1))];
     b = [ cornerPoints(2,2), cornerPoints(3,2)];

     cornerPointsXY2(3,:) =  M\(b.'); 

     M = [cos(cornerPoints(2,1)), sin(cornerPoints(2,1)); cos(cornerPoints(4,1)), sin(cornerPoints(4,1))];
     b = [ cornerPoints(2,2), cornerPoints(4,2)];

     cornerPointsXY2(4,:) =  M\(b.');
     
       %mask the image according to outlines
       cropIm{n,1} = cropDomino(cornerPointsXY1,A);
       cropIm{n,2} = cropDomino(cornerPointsXY2,A);

       %% CROP MASKED IMAGES TO SMALLES POSSIBLE IMAGE IN ORDER TO SAVE OPERATING TIME WHEN READING CIRCLES
       
        %get x,y, width, height image 1
        xLong = max(cornerPointsXY1(:,1));
        yLong = max(cornerPointsXY1(:,2));
        xShort = min(cornerPointsXY1(:,1));
        yShort = min(cornerPointsXY1(:,2));

        Width = xLong - xShort;
        Height = yLong - yShort;

        rect = [xShort, yShort, Width, Height];

        cropIm{n,1} = imcrop(cropIm{n,1}, rect );

        %do the same for image 2
        xLong = max(cornerPointsXY2(:,1));
        yLong = max(cornerPointsXY2(:,2));
        xShort = min(cornerPointsXY2(:,1));
        yShort = min(cornerPointsXY2(:,2));

        Width = xLong - xShort;
        Height = yLong - yShort;

        rect = [xShort, yShort, Width, Height];

        cropIm{n,2} = imcrop(cropIm{n,2}, rect );
        
        
        %% READ THE NUMBER OF CIRCLES IN EVERY SUBELEMENTARY PICTURE


    %read the crops

           temp1 = numberDomino2(cropIm{n,1});
           temp2 = numberDomino2(cropIm{n,2});
           
           if temp2 < temp1
               numberIm(1,1) = temp2;
               numberIm(1,2) = temp1;
           else 
               numberIm(1,1) = temp1;
               numberIm(1,2) = temp2;
           end

    %save value into mega array

            Domino(n).Value = numberIm(1,:);
    
            %% GET THE INDIVIDUAL NUMBER OF EVERY DOMINO
            
    Domino(n).Rank = rankDomino(Domino(n).Value);
    

            
    %% GIVE CORNER POINTS FOR MOTION PLANNING. CORNER POINTS MUST BE IN CLOCKWISE DIRECTION STARTING WITH 1-2 at the shot side
    cornerPoints(1:2,1:2) = cornerPointsXY1(3:4,1:2);
    cornerPoints(3:4,1:2) = cornerPointsXY2(1:2,1:2);
    
    % for special cas 90 degrees
    if Domino(n).Orientation == 90
        compare1 = min(cornerPoints(1,1), cornerPoints(2,1));
        compare2 = min(cornerPoints(3,1), cornerPoints(4,1));
        
        if compare2 < compare1 
            cornerPointsBuf(1:2,1:2) = cornerPoints(3:4,1:2);
            cornerPointsBuf(3:4,1:2) = cornerPoints(1:2,1:2);
            cornerPoints = cornerPointsBuf;
        end
        
        %step b: get the order according to y (large, small, small, large) --> clockwise
        if cornerPoints(1,2) < cornerPoints(2,2)
            cornerPointsBuf(1,:) = cornerPoints(2,:);
            cornerPointsBuf(2,:) = cornerPoints(1,:);
        end
            
        if cornerPoints(4,2) < cornerPoints(3,2)
            cornerPointsBuf(3,:) = cornerPoints(4,:);
            cornerPointsBuf(4,:) = cornerPoints(3,:);
        end
            
        cornerPoints = cornerPointsBuf;
        
        Domino(n).CornerPoints = cornerPoints;
    
    %for all other cases
    
    else 
        %get the 'upper' or 'left' pair by getting the smallest y value
        compare1 = min(cornerPoints(1,2), cornerPoints(2,2));
        compare2 = min(cornerPoints(3,2), cornerPoints(4,2));
        if compare2 < compare1 
            cornerPointsBuf(1:2,1:2) = cornerPoints(3:4,1:2);
            cornerPointsBuf(3:4,1:2) = cornerPoints(1:2,1:2);
            cornerPoints = cornerPointsBuf;
        end
        
        %step b: get the order according to x values (small, large, large
        %small --> clockwise
        if cornerPoints(2,1) < cornerPoints(1,1)
            cornerPointsBuf(1,:) = cornerPoints(2,:);
            cornerPointsBuf(2,:) = cornerPoints(1,:);
        end
            
        if cornerPoints(3,1) < cornerPoints(4,1)
            cornerPointsBuf(3,:) = cornerPoints(4,:);
            cornerPointsBuf(4,:) = cornerPoints(3,:);
        end
            
        cornerPoints = cornerPointsBuf;
        
        Domino(n).CornerPoints = cornerPoints;
    end
    
end
   

%% DISPLAY THE RESULTS IN A FIGURE
%display big (random boxes) around centroids and label number to it. 

 %write Label for every domino
 
 for i=1:Domino(1).Count
    dominoLabel{i} = [ num2str(Domino(i).Value(1)) '-' num2str(Domino(i).Value(2)) '-deg:' num2str(Domino(i).Orientation) ];
 end
 
  for i=1:Domino(1).Count
    CircleLocation(i,1:3) = [Domino(i).Location, 36]; 
 end
 
 
 %display Boxes in image
 ABox = insertObjectAnnotation(A,'circle', CircleLocation, dominoLabel, 'FontSize', 18);
 
%Display the detected domino with the titel of the number of dominoes
%detected
figure;

imshow(ABox);
title(['There is/are ' ,num2str(Domino(1).Count), 'Dominoe(s) in the frame']);


    %% SCALE THE DOMINOES CORRECTLY
    for n = 1:Domino(1).Count
        Domino(n).Location = Domino(n).Location/3
    end
end
