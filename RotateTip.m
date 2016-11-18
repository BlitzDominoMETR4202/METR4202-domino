function RotateTip(angle)

%for ax: 1 = 0.29degrees
O_left90 = 202;     %-90degrees
Ocenter = 512;      %0degrees
O_right90 = 822;    %90degrees
Ospeed = 150;

%conversions to value that motors can use
    oTarget = Ocenter - angle * (310/90);



%setup
%loadlibrary('dynamixel','dynamixel.h');
%functions('dynamixel');
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



    %calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    %calllib('dynamixel','dxl_write_word',ax_2,speed,Ospeed);%max 28672
    
    calllib('dynamixel','dxl_write_word',ax_2,P_GOAL_POSITION,oTarget);%max 15000
    Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
    while Moving == 1
        pause(0.01)
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
    end
    %PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_2,P_PRESENT_POSITION));
    %fprintf('O Position: %i\n', PresentPos);
    %calllib('dynamixel','dxl_terminate');


end