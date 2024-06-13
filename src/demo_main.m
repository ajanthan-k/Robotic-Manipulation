% Read the position of the dynamixel horn with the torque off
% The code executes for a given amount of time then terminates


clc;
clear all;

lib_name = '';

if strcmp(computer, 'PCWIN')
  lib_name = 'dxl_x86_c';
elseif strcmp(computer, 'PCWIN64')
  lib_name = 'dxl_x64_c';
end

% Load Libraries
if ~libisloaded(lib_name)
    [notfound, warnings] = loadlibrary(lib_name, 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h');
end

%% ---- Control Table Addresses ---- %%

ADDR_PRO_DRIVE_MODE          = 10;
ADDR_PRO_OPERATING_MODE      = 11;
ADDR_PRO_HOMING_0FFSET       = 20;

ADDR_PRO_TORQUE_ENABLE       = 64;         
ADDR_PRO_GOAL_POSITION       = 116; 
ADDR_PRO_PRESENT_POSITION    = 132; 
ADDR_POS_P_GAIN              = 84;
ADDR_POS_I_GAIN              = 82;
ADDR_POS_D_GAIN              = 80;

ADDR_MAX_POS = 48;
ADDR_MIN_POS = 52;

% ---- Other Settings ---- %

% Protocol version
PROTOCOL_VERSION            = 2.0;          % See which protocol version is used in the Dynamixel

DXL_IDS                     = [11, 12, 13, 14, 15];
BAUDRATE                    = 115200;
DEVICENAME                  = 'COM5';       % Check which port is being used on your controller
                                            % ex) Windows: 'COM1'   Linux: '/dev/ttyUSB0' Mac: '/dev/tty.usbserial-*'
                                            
TORQUE_ENABLE               = 1;            % Value for enabling the torque
TORQUE_DISABLE              = 0;            % Value for disabling the torque
DXL_MOVING_STATUS_THRESHOLD = 20;           % Dynamixel moving status threshold

ESC_CHARACTER               = 'e';          % Key for escaping loop

COMM_SUCCESS                = 0;            % Communication Success result value
COMM_TX_FAIL                = -1001;        % Communication Tx Failed

%% --------CONNECTION---------- %%

% Initialize PortHandler Structs
% Set the port path
% Get methods and members of PortHandlerLinux or PortHandlerWindows
port_num = portHandler(DEVICENAME);

% Initialize PacketHandler Structs
packetHandler();

dxl_comm_result = COMM_TX_FAIL;           % Communication result
dxl_error = 0;                              % Dynamixel error
dxl_present_position = 0;                   % Present position


% Open port
if (openPort(port_num))
    fprintf('Port Open\n');
else
    unloadlibrary(lib_name);
    fprintf('Failed to open the port\n');
    input('Press any key to terminate...\n');
    return;
end

% Set port baudrate
if (setBaudRate(port_num, BAUDRATE))
    fprintf('Baudrate Set\n');
else
    unloadlibrary(lib_name);
    fprintf('Failed to change the baudrate!\n');
    input('Press any key to terminate...\n');
    return;
end

% Disable Dynamixel Torque
% special ID 254 (stands for ALL Dynamixels used)
write4ByteTxRx(port_num, PROTOCOL_VERSION, 254, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);

dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);

if dxl_comm_result ~= COMM_SUCCESS
    fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
elseif dxl_error ~= 0
    fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
else
    fprintf('Dynamixel has been successfully connected \n');
end

%% ---------------DYNAMIXEL-INIT------------------- %%

if (initDynamixels(port_num, PROTOCOL_VERSION) ~= 0)
    fprintf('Dynamixels not initialised correctly \n');
end

% VA in time based profile
% Profile Acceleration(108) sets acceleration time of the Profile.
% Profile Velocity(112) sets the time span to reach the velocity (the total time) of the Profile.
% 0-30,000 where 0 is max. E.g. 5000 ->  movement is done around 5s theoretically.
setVAProfile(2000,200,port_num);

write4ByteTxRx(port_num, PROTOCOL_VERSION, 254, ADDR_PRO_TORQUE_ENABLE, 1);

%% ---------------HOME------------------- %%

movePos([0,10,10,-90], port_num, 2.0);
% write4ByteTxRx(port_num, PROTOCOL_VERSION, 254, ADDR_PRO_TORQUE_ENABLE, 0);
% disp(readPos(port_num, 3));

%% Task 2
% Pre-calculations
cube_starts = {[-2,7],[7,7],[-7,0]};
cube_ends = {[6,0],[3.9,3.9],[0,9]};
current_pose = [0,15,10,-90];

cube_orientations = {"towards", "down", "away"}; % demo day 
% cube_orientations = {"away","down","away"}; % video demo
% cube_orientations = {"up","up","up"}; %for testing stacking w/o rotation

% SELECT TASK HERE
task_code = "2b";
if (task_code == "2a")
    commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
elseif (task_code == "2b")
    commands = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
else
    commands = Task_2("c", cube_starts, cube_ends, cube_orientations, current_pose);
end

% Movement
setVAProfile(800,100,port_num); % set profile
movePos([0, 15, 10, -90], port_num); % move to known pos
openGripper(1, 1, port_num); % open gripper
runCommands(commands, port_num); % do task

%% demo
% TASK 2A REAL
setVAProfile(800,100,port_num); % set profile
current_pose = [0,15,5,-90];
cube_orientations = {"towards", "down", "away"}; % demo day 
% Move cube 1 to (4,4) first for easier rotation)

cube_starts = {[-2,7],[7,7],[-7,0]};
cube_ends = {[6,0],[3.85,3.85],[0,9]};

commands_2a = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands_2a, port_num);
%% DON'T RUN THIS
setVAProfile(800,100,port_num); % set profile
current_pose = [0,15,5,-90];
%% TASK 2B REAL
% Rotate cube at [-2, 7] to up
cube_starts = {[-2,7]};
cube_ends = {[-2,7]};
cube_orientations = {"down"};
commands = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Move to [-4, 4]
cube_starts = {[-2,7]};
cube_ends = {[3.9,3.9]};
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Translate (7,7) to (-2,7)
cube_starts = {[7,7]};
cube_ends = {[-2,7]};
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Rotate cubes at [0,9]
cube_starts = {[-2,7]};
cube_ends = {[-2,7]};
cube_orientations = {"towards"};
commands = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Reverse the translation
cube_starts = {[-2,7],[-7,0]};
cube_ends = {[6.95,6.95],[-2,7]};
cube_orientations = {"towards", "away"};
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Rotate cubes at [-2,7]
cube_starts = {[-2,7]};
cube_ends = {[-2,7]};
cube_orientations = {"away"};
commands = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Translate [-27 to -7,0]
cube_starts = {[-2,7], [4,4]};
cube_ends = {[-6.6,0], [-2,6.95]};
cube_orientations = {"towards", "away"};
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
%% TASK 2C REAL
% Rotate cube at [-2, 7] to up
cube_starts = {[-2,7]};
cube_ends = {[-2,7]};
cube_orientations = {"down"};
commands = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Move to [-4, 4]
cube_starts = {[-2,7]};
cube_ends = {[3.9,3.9]};
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Translate (7,7) to (-2,7)
cube_starts = {[7,7]};
cube_ends = {[-2,7]};
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Rotate cubes at [0,9]
cube_starts = {[-2,7]};
cube_ends = {[-2,7]};
cube_orientations = {"towards"};
commands = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Reverse the translation
cube_starts = {[-2,7],[-7,0]};
cube_ends = {[6.95,6.95],[-2,7]};
cube_orientations = {"towards", "away"};
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Rotate cubes at [-2,7]
cube_starts = {[-2,7]};
cube_ends = {[-2,7]};
cube_orientations = {"away"};
commands = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Translate [-27 to -7,0]
cube_starts = {[-2,7], [4,4]};
cube_ends = {[-6.6,0], [-2,6.95]};
cube_orientations = {"towards", "away"};
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
current_pose = commands(end,:);
% Task c
cube_starts = {[-7,0],[-2,7],[7,7]};
cube_ends = {[3.95,3.95],[-2,7],[-7,0]};
final_end = cube_ends{1};
for i = 1:numel(cube_ends)
    cube_ends{i} = [final_end(1), final_end(2), i-0.5];
end
commands = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
runCommands(commands, port_num);
%% Task 3
% Calculations
placement = [8,0];
setVAProfile(1000,200,port_num); 
current_pose = [0,10,10,-90];
% current_pose = [0,15,10,-90];
commands_3pickup = Task_3("pickup", placement, current_pose);
commands_3dropoff = Task_3("dropoff", placement, current_pose);

% Movement
runCommands(commands_3pickup, port_num);
% runCommands(commands_3dropoff, port_num);

%% 

movePos([-17, 10, 2, -60], port_num, 2.0, 2);
% setVAProfile(200,100,port_num);
setVAProfile(100,50,port_num);

%pen down
movePos([-17, 10, 0.8, -60], port_num, 2.0, 2);

moveStraightLine([-17, 10, 0.8, -60], [-16.5, 20, 0.8, -60], 50, port_num, 0.08);
pause(1);
moveStraightLine([-16.5, 20, 0.9, -60], [-12 ,15 ,0.4,-60], 50, port_num, 0.08);
pause(1);
moveStraightLine([-12, 15 ,0.4,-60], [-16.8, 15, 0.9, -60], 50, port_num, 0.08);

pause(1);

moveArc(-16.5, 17, 0., -60, 2.5, 3*pi/2, 6*pi/2, 60, port_num, 0.08);
pause(2);

setVAProfile(1000,100,port_num);
movePos([-20, 17.5, 5, -60], port_num, 1.0, 2);
movePos([-10, 16, 15, -60], port_num, 1);


% In theory, better to update pos before it stops motion when trajectory
% following?

%%
setVAProfile(1000,200,port_num); 
runCommands(commands_3dropoff, port_num);

%% Task 4

Task_4(port_num);

%% Record egg crack

write4ByteTxRx(port_num, PROTOCOL_VERSION, 254, ADDR_PRO_TORQUE_ENABLE, 0);
write4ByteTxRx(port_num, PROTOCOL_VERSION, 15, ADDR_PRO_TORQUE_ENABLE, 1);
% recordMotion(6, 3, port_num)

%% ---------------RESET------------------- %%
setVAProfile(2000,200,port_num);
% movePos([0, 15, 1, -90], port_num, 2.0);

% Disable Dynamixel Torque                                                                                                                                          
write4ByteTxRx(port_num, PROTOCOL_VERSION, 254, ADDR_PRO_TORQUE_ENABLE, 0);

dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
if dxl_comm_result ~= COMM_SUCCESS
    fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
elseif dxl_error ~= 0
    fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
end

% Close port
closePort(port_num);
fprintf('Port Closed \n');

% Unload Library
unloadlibrary(lib_name);

close all;
clear all;

%% HELPER FUNCTIONS

% Encoder angle -> degrees function
function degrees = encToDeg(angle)
    degrees = angle*45/512;
end
% Encoder angle -> radians function
function radians = encToRad(angle)
    radians = angle*pi/2048;
end

function encoder = degToEnc(angle)
    encoder = (angle / 360) * 4096;
end

function encoder = radToEnc(angle)
    encoder = (angle / (2*pi)) * 4096;
end

