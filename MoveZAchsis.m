function MoveZAchsis(position)
%Down value is 620 
%up value is 510

compare = strcmp(position, 'up')
if compare == 1
    Zposition = 520;
end
if compare == 0
    Zposition = 615;
end

%95 and 520
motorspeed = 120;

%motor 3 moves to position 512 (up position)
%motor is in joint mode and only have a range of 300degrees

%setup
%loadlibrary('dynamixel','dynamixel.h');
%libfunctions('dynamixel');

%Setting
id = 3;
mx_1 = 1;
mx_2 = 2;
ax_1 = 3;
ax_2 = 4;
P_GOAL_POSITION = 30; %command table entry
P_PRESENT_POSITION = 36;
DEFAULT_PORTNUM = 3; % com3
DEFAULT_BAUDNUM = 1; % 1mbps
P_Moving = 46;
speed = 32;

int32 GoalPos;
int32 index;
int32 PresentPos;
int32 Moving;
int32 CommStatus;

%calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
%calllib('dynamixel','dxl_write_word',id,speed,motorspeed);%max 28672

calllib('dynamixel','dxl_write_word',id,P_GOAL_POSITION,Zposition);%max 28672 652
Moving = int32(calllib('dynamixel','dxl_read_byte',id,P_Moving));
while Moving == 1
    pause(0.01)
    Moving = int32(calllib('dynamixel','dxl_read_byte',id,P_Moving));
end
PresentPos = int32(calllib('dynamixel','dxl_read_word',id,P_PRESENT_POSITION));
fprintf('O Position: %i\n', PresentPos);

end


