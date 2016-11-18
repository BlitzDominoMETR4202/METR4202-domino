%This is the main code to control the DOMINO robot

%% initialise
%connect camera manually 
%run camera calibration --> use webcamlist --> install support package if
%required
loadlibrary('dynamixel','dynamixel.h');
libfunctions('dynamixel');
mx_1 = 1;%X
mx_2 = 2;%Y
ax_1 = 3;%Z
ax_2 = 4;%O
P_GOAL_POSITION = 30; %command table entry
P_PRESENT_POSITION = 36;
DEFAULT_PORTNUM = 3; % com4
DEFAULT_BAUDNUM = 1; % 1mbps
P_Moving = 46;
speed = 32;
int32 GoalPos;
int32 index;
int32 PresentPos;
int32 Moving;
int32 CommStatus;
calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
calllib('dynamixel','dxl_write_word',1 ,speed,55);
calllib('dynamixel','dxl_write_word',2 ,speed,45);
calllib('dynamixel','dxl_write_word',3 ,speed,120);
calllib('dynamixel','dxl_write_word',4 ,speed,150);


xMotor = 1;
yMotor = 2;

MoveXYAchsis(1,190);
pause(0.5);
MoveXYAchsis(1,190);
pause(0.5);

MoveXYAchsis(yMotor,0);
pause(0.5);
MoveXYAchsis(yMotor,0);
pause(0.5);

MoveZAchsis('up');
pause(0.5);
MoveZAchsis('up');
pause(0.5);
try
    if first_run == 0
        %do nothing
    end
catch
    Blitz_zhangcalibrate();
    Blitz_matlab_scc();
end

xMotor = 1;
yMotor = 2;

pause(0.5);
%run distortion function with cpt2form + obtain origin
Blitz_CameraCalib();
pause(0.5);

MoveXYAchsis(xMotor,0);
pause(0.5);
MoveXYAchsis(xMotor,0);
pause(0.5);
%move all motors to initial position


%% Parameters
xMotor = 1;%X
yMotor = 2;%Y


%% START the main Code

%initialise array of 'parked' dominoes, the row indicates the number,
%column1: placed = 1, not placed = 0,
%dont forget to set the value to 1 
dominoDistance = 35;
dominoWidth = 0;
offsetLeft = 63;
offsetTop = 63;
YachsisMax = 280;
vertical = 0;
horizontal = 90; 
ParkDomino = [0, offsetLeft, dominoWidth, vertical;  ...
    0, offsetLeft + dominoDistance*1, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*2, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*3, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*4, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*5, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*6, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*7, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*8, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*9, dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*10, dominoWidth, vertical;...
    0, offsetLeft, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*1, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*2, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*3, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*4, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*5, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*6, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*7, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*8, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*9, YachsisMax - dominoWidth, vertical;...
    0, offsetLeft + dominoDistance*10, YachsisMax - dominoWidth, vertical;...
    0, 0, offsetTop, horizontal;...
    0, 0, offsetTop + dominoDistance*1, horizontal;...
    0, 0, offsetTop + dominoDistance*2, horizontal;...
    0, 0, offsetTop + dominoDistance*3, horizontal;...
    0, 0, offsetTop + dominoDistance*4, horizontal;...
    0, 0, offsetTop + dominoDistance*5, horizontal ];
    

%-------------------------------
%while not all dominoes are in position:
while 1>0
    
%get Picture. PUT the cropping function. 
%process picture (undistort, crop, maybe crop only area of actual interest) 
%get domino data
Blitz_CameraCalib();
A = I_cropped;

A(1:250,1:1261,1) = 0;
A(1:250,1:1261,2) = 0;
A(1:250,1:1261,3) = 0;

A(1:841,1:316,1) = 0;
A(1:841,1:316,2) = 0;
A(1:841,1:316,3) = 0;

A(607:841,1:1261,1) = 0;
A(607:841,1:1261,2) = 0;
A(607:841,1:1261,3) = 0;

Domino = DominoData(A); %remember to delete the data in order to avoid problems with remaining data

%compare with parked dominoes --> get the dominoes that actually need to be
%moved.
n = 1;
    while n <= Domino(1).Count
        identifier = Domino(n).Rank;
        if ParkDomino(identifier,1) == 1
            Domino(n) = [];
            Domino(1).Count = Domino(1).Count - 1;
            %fprintf('I will ignore one domino, because this domino does not belong to the set or because I have a problem recognising this domino'); 
        end
        n = n+1;
    end

%If a domino is already parked but also recognised: "I cant recognise it
%and scratch that domino
%dont forget to add this statement in the end of the loop
if Domino(1).Count <= 0
    if sum(ParkDomino(:,1)) == 28
        fprintf('All dominoes sorted!');
        break
    else
        fprintf('Please add more dominoes to the workspace. Click to continue');
        pause;
        continue
    end
end

    
%decide for a domino (probably leftmost)
compareSmallest = 8000;
for n = 1:Domino(1).Count
    compareNew = Domino(n).Location(1,1);
    if compareNew < compareSmallest
        movingDomino = n;
        compareSmallest = compareNew;
    end
    
end


%__________________________
%move the domino
%parameters
rotateLocation = 170;

%set X, y to the centroid of the domino
%disp(Domino(movingDomino).Location)
MoveXYAchsis(xMotor, Domino(movingDomino).Location(1,1));
pause(0.5);
MoveXYAchsis(xMotor, Domino(movingDomino).Location(1,1));
pause(0.5);

MoveXYAchsis(yMotor, Domino(movingDomino).Location(1,2));
pause(0.5);
MoveXYAchsis(yMotor, Domino(movingDomino).Location(1,2));
pause(0.5);

%set the angle to the angle of the domino
disp(Domino(movingDomino).Orientation)
RotateTip(Domino(movingDomino).Orientation);
pause(0.5);
%touch the domino
disp('down')
MoveZAchsis('down');
pause(0.5);

%move towards left --> x minus
disp(rotateLocation)
MoveXYAchsis(xMotor, rotateLocation);
pause(0.5);
MoveXYAchsis(xMotor, rotateLocation);
pause(0.5);

%find out the target location
Rank = Domino(movingDomino).Rank;

%rotate to target angle
RotateTip(ParkDomino(Rank,4));
pause(0.5);

%if top or bottom: align x first, then y
if ParkDomino(Rank,4) == vertical
    if ParkDomino(Rank,3) == 0
        MoveXYAchsis(yMotor,60); 
        MoveXYAchsis(xMotor,ParkDomino(Rank,2));
        MoveXYAchsis(yMotor,ParkDomino(Rank,3));
    else
        MoveXYAchsis(yMotor,220); 
        MoveXYAchsis(xMotor,ParkDomino(Rank,2));
        MoveXYAchsis(yMotor,ParkDomino(Rank,3)); 
    end
end
%if side: align y first, then x
if ParkDomino(Rank,4) == horizontal
    MoveXYAchsis(yMotor,ParkDomino(Rank,3));
    pause(0.5);
    MoveXYAchsis(yMotor,ParkDomino(Rank,3));
    pause(0.5);

    MoveXYAchsis(xMotor,ParkDomino(Rank,2));    
    pause(0.5);
    MoveXYAchsis(xMotor,ParkDomino(Rank,2));    
    pause(0.5);
end
%lift up
MoveZAchsis('up');
pause(0.5);
MoveZAchsis('up');
pause(0.5);

%move x towards the left to get a good photo
MoveXYAchsis(xMotor,0); 
pause(0.5);
MoveXYAchsis(xMotor,0); 
pause(0.5);
%note that the domino is placed correctly
ParkDomino(Rank,1) = 1;
disp('Re-align robot');
pause;
end
calllib('dynamixel','dxl_terminate');
%________________________________
%loop returns


%put in limits for the motors --> done
%detect the right spots  ( get a second variable target domino) --> done
%measure the maximum space and enter the variables


