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

% Default setting
DXL_IDS                     = [11, 12, 13, 14, 15];
BAUDRATE                    = 115200;
DEVICENAME                  = 'COM8';       % Check which port is being used on your controller
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
write1ByteTxRx(port_num, PROTOCOL_VERSION, 254, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);

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

% Set actuator limits
% MAX_POS = [2200, 2200, 4000, 3100, 2600];
% MIN_POS = [0, 50, 2000, 650, 1400];
% for i = 1: 5
%     write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_MAX_POS, MAX_POS(i));
%     write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_MIN_POS, MIN_POS(i));
% end

if (initDynamixels(port_num, PROTOCOL_VERSION) ~= 0)
    fprintf('Dynamixels not initialised correctly \n');
end

% VA in time based profile
% Profile Acceleration(108) sets acceleration time of the Profile.
% Profile Velocity(112) sets the time span to reach the velocity (the total time) of the Profile.
% 0-30,000 where 0 is max. E.g. 5000 ->  movement is done around 5s theoretically.
setVAProfile(2000,200,port_num);

write1ByteTxRx(port_num, PROTOCOL_VERSION, 254, ADDR_PRO_TORQUE_ENABLE, 1);

%% ---------------HOME------------------- %%

movePos(0, 10, 10, -90, port_num);
pause(2);

%% Task 2

setVAProfile(1000,100,port_num);

% movePos(0, 15, 15, -80, port_num); % move to known pos
openGripper(2,0,port_num)


%%
% cube_starts = {[8,3],[0,9],[-6,6]};
% cube_ends = {[5,5],[0,4],[-4,0]};
% current_pose = [0,15,5,-90];
% cube_orientations = {"away","down","towards"}; % all rotation possibilities
% cube_orientations = {"away","down","away"}; % video demo
% cube_orientations = {"up","up","up"}; %for testing stacking w/o rotation
% 
% % commands_2a = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
% % commands_2b = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
% % commands_2c = Task_2("c", cube_starts, cube_ends, cube_orientations, current_pose);
% 
% placement = [8,0];
% % current_pose = [0,15,5,-90];
% commands_3pickup = Task_3("pickup", placement, current_pose);
% commands_3dropoff = Task_3("dropoff", placement, current_pose);
% 
% runCommands(commands_3pickup, port_num);

% In theory, better to update pos before it stops motion when trajectory
% following?


%% ---------------RESET------------------- %%
movePos(0, 15, 2, -90, port_num);
pause(2);

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

function setVAProfile(velocity, accel, port_num)
    DXL_IDS = [11, 12, 13, 14, 15];
    for i = 1:5
        write4ByteTxRx(port_num, 2.0, DXL_IDS(i), 112, velocity);
        write4ByteTxRx(port_num, 2.0, DXL_IDS(i), 108, accel);
    end
end

