%setup
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

%input
%for mx: 1 = 0.088 degrees, for ax: 1 = 0.29degrees
Xmin = 8;           %left of box (camera position)
Xmax = 23500;%TEST THIS
Ymin = 0;           %top of box (camera position)
Ymax = 15000;
Zmin = 512;         %up
Zmax = 652;         %down
O_left90 = 202;     %-90degrees
Ocenter = 512;      %0degrees
O_right90 = 822;    %90degrees
%for mx: 1 = 0.114rpm, for ax: 1 = 0.111rpm 
Xspeed = 20;
Yspeed = 20;
Zspeed = 60;
Ospeed = 100;

%To setup, do one motor(while loop) on at a time, turn b&f and looping off
%turn on by loop to 1, 
%turn back and forth on by turning IF to 1,
%turn looping on by setting loop within while to 1.

%%X%%
loop1 = 0;
while loop1
    calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    calllib('dynamixel','dxl_write_word',mx_1,speed,Xspeed);%max 28672
    calllib('dynamixel','dxl_write_word',mx_1,P_GOAL_POSITION,Xmin);%max 24000
    Moving = int32(calllib('dynamixel','dxl_read_byte',mx_1,P_Moving));
    while Moving == 1
        pause(0.01)
        Moving = int32(calllib('dynamixel','dxl_read_byte',mx_1,P_Moving));
    end
    PresentPos = int32(calllib('dynamixel','dxl_read_word',mx_1,P_PRESENT_POSITION));
    fprintf('X Position: %i\n', PresentPos);
    if 0
        calllib('dynamixel','dxl_write_word',mx_1,P_GOAL_POSITION,Xmax);%max 24000
        Moving = int32(calllib('dynamixel','dxl_read_byte',mx_1,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',mx_1,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',mx_1,P_PRESENT_POSITION));
        fprintf('X Position: %i\n', PresentPos);
        calllib('dynamixel','dxl_write_word',mx_1,P_GOAL_POSITION,Xmin); %min 8
        Moving = int32(calllib('dynamixel','dxl_read_byte',mx_1,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',mx_1,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',mx_1,P_PRESENT_POSITION));
        fprintf('X Position: %i\n', PresentPos);
    end
    calllib('dynamixel','dxl_terminate');
    loop1 = 0;
end

%%Y%%
loop2 = 0;
while loop2
    calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    calllib('dynamixel','dxl_write_word',mx_2,speed,Yspeed);
    calllib('dynamixel','dxl_write_word',mx_2,P_GOAL_POSITION,Ymin);
    Moving = int32(calllib('dynamixel','dxl_read_byte',mx_2,P_Moving));
    while Moving == 1
        pause(0.01)
        Moving = int32(calllib('dynamixel','dxl_read_byte',mx_2,P_Moving));
    end
    PresentPos = int32(calllib('dynamixel','dxl_read_word',mx_2,P_PRESENT_POSITION));
    fprintf('Y Position: %i\n', PresentPos);
    if 0
        calllib('dynamixel','dxl_write_word',mx_2,P_GOAL_POSITION,Ymax);
        Moving = int32(calllib('dynamixel','dxl_read_byte',mx_2,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',mx_2,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',mx_2,P_PRESENT_POSITION));
        fprintf('Y Position: %i\n', PresentPos);
        calllib('dynamixel','dxl_write_word',mx_2,P_GOAL_POSITION,Ymin);
        Moving = int32(calllib('dynamixel','dxl_read_byte',mx_2,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',mx_2,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',mx_2,P_PRESENT_POSITION));
        fprintf('Y Position: %i\n', PresentPos);
    end
    loop2 = 0;
    calllib('dynamixel','dxl_terminate');
end
    
%%Z%%
loop3 = 0;
while loop3
    calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    calllib('dynamixel','dxl_write_word',ax_1,speed,Zspeed);%max 28672
    
    calllib('dynamixel','dxl_write_word',ax_1,P_GOAL_POSITION,Zmin);%max 15000
    Moving = int32(calllib('dynamixel','dxl_read_byte',ax_1,P_Moving));
    while Moving == 1
        pause(0.01)
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_1,P_Moving));
    end
    PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_1,P_PRESENT_POSITION));
    fprintf('Z Position: %i\n', PresentPos);
    if 0
        calllib('dynamixel','dxl_write_word',ax_1,P_GOAL_POSITION,Zmax);%max 15000
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_1,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',ax_1,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_1,P_PRESENT_POSITION));
        fprintf('Z Position: %i\n', PresentPos);
        calllib('dynamixel','dxl_write_word',ax_1,P_GOAL_POSITION,Zmin);%max 15000
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_1,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',ax_1,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_1,P_PRESENT_POSITION));
        fprintf('Z Position: %i\n', PresentPos);
    end
    loop3 = 0;
    calllib('dynamixel','dxl_terminate');
end

%%O%%
loop4 = 1;
while loop4
    calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    calllib('dynamixel','dxl_write_word',ax_2,speed,Ospeed);%max 28672
    
    calllib('dynamixel','dxl_write_word',ax_2,P_GOAL_POSITION,Ocenter);%max 15000
    Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
    while Moving == 1
        pause(0.01)
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
    end
    PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_2,P_PRESENT_POSITION));
    fprintf('O Position: %i\n', PresentPos);
    if 1
        calllib('dynamixel','dxl_write_word',ax_2,P_GOAL_POSITION,O_left90);
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_2,P_PRESENT_POSITION));
        fprintf('O Position: %i\n', PresentPos);
        calllib('dynamixel','dxl_write_word',ax_2,P_GOAL_POSITION,Ocenter);
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_2,P_PRESENT_POSITION));
        fprintf('O Position: %i\n', PresentPos);
        calllib('dynamixel','dxl_write_word',ax_2,P_GOAL_POSITION,O_right90);
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_2,P_PRESENT_POSITION));
        fprintf('O Position: %i\n', PresentPos);
        calllib('dynamixel','dxl_write_word',ax_2,P_GOAL_POSITION,Ocenter);
        Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
        while Moving == 1
            pause(0.01)
            Moving = int32(calllib('dynamixel','dxl_read_byte',ax_2,P_Moving));
        end
        PresentPos = int32(calllib('dynamixel','dxl_read_word',ax_2,P_PRESENT_POSITION));
        fprintf('O Position: %i\n', PresentPos);
    end
    loop4 = 0;
    calllib('dynamixel','dxl_terminate');
end