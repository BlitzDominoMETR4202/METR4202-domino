function MoveXYAchsis(id,xTarget)
%id= mx_1 for x motor and id =mx_2 for y motor target must be in degrees
%calibration for x achsis 10th upper tooth
%calibration of y achsis 

xTarget = xTarget * 360/(25*0.088*pi);
if id == 1;
    if xTarget> 21877
        xTarget = 21877;
    elseif xTarget <0
        xTarget = 0;
    end
else
    if xTarget> 14584
        xTarget = 14584;
    elseif xTarget <0
        xTarget = 0;
    end
end


%setup
%loadlibrary('dynamixel','dynamixel.h');
%libfunctions('dynamixel');
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

%input
%for mx: 1 = 0.088 degrees, for ax: 1 = 0.29degrees
Xmin = 8;           %left of box (camera position)
Xmax = 24000;
Ymin = 0;           %top of box (camera position)
Ymax = 15000;
Zmin = 512;         %up
Zmax = 652;         %down
%for mx: 1 = 0.114rpm, for ax: 1 = 0.111rpm 
Xspeed = 35;


%%X or Y %%

    %calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    %calllib('dynamixel','dxl_write_word',id ,speed,Xspeed);%max 28672
    
    calllib('dynamixel','dxl_write_word',id,P_GOAL_POSITION,xTarget);%max 24000
    Moving = int32(calllib('dynamixel','dxl_read_byte',id,P_Moving));
    PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_2,P_PRESENT_POSITION));
    while and(and(Moving == 0, PresentPos >= xTarget +100), PresentPos <= xTarget -100)
        pause(0.01)
        Moving = int32(calllib('dynamixel','dxl_read_byte',id,P_Moving));
        PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_2,P_PRESENT_POSITION));
        calllib('dynamixel','dxl_write_word',id,P_GOAL_POSITION,xTarget);
       
        disp('running again')
    end
    
    while Moving == 1
        pause(0.01)
        Moving = int32(calllib('dynamixel','dxl_read_byte',id,P_Moving));
    end
    %PresentPos = int32(calllib('dynamixel','dxl_read_word',mx_1,P_PRESENT_POSITION));
    %fprintf('X Position: %i\n', PresentPos);
    %calllib('dynamixel','dxl_terminate');
    
    
    
    
end
 


