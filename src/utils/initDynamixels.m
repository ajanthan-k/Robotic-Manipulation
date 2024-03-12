function status = initDynamixels(port_num, PROTOCOL_VERSION)
    % Initialize all dynamixels
    
    %% Dynamixel parameters
    ADDR_PRO_DRIVE_MODE          = 10;
    ADDR_PRO_OPERATING_MODE      = 11;
    ADDR_PRO_HOMING_0FFSET       = 20;
    
    ADDR_PRO_TORQUE_ENABLE       = 64;         
    ADDR_POS_P_GAIN              = 84;
    ADDR_POS_I_GAIN              = 82;
    ADDR_POS_D_GAIN              = 80;
    
    ADDR_MAX_POS = 48;
    ADDR_MIN_POS = 52;
    
    DXL_IDS = [11, 12, 13, 14, 15];
    
    % Put actuators into Position Control Mode
    for i = 1:5
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_PRO_OPERATING_MODE, 3);
    end
    
    % Set drive mode to time-based profile - give a time to reach goal by
    % Set Bit 0 to 1 for Reverse (Clockwise Positive) - i.e. Drive mode = 5
    drive_modes = [4, 5, 5, 5, 4];
    for i = 1:5
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_PRO_DRIVE_MODE, drive_modes(i));
    end
    
    % refactor to do all offsets in code
    homing_offsets = [-1024, 1024, -1024];
    for i = 1:3
        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_PRO_HOMING_0FFSET, homing_offsets(i));
    end
    
    % Set actuator limits
    MAX_POS = [2200, 2200, 4000, 3100, 2600];
    MIN_POS = [0, 50, 2000, 650, 1400];
    for i = 1:5
        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_MAX_POS, MAX_POS(i));
        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_MIN_POS, MIN_POS(i));
    end
    
    % Set PID for actuator 2 - shoulder
    PID_values = [400, 50, 0]; % default is 800 0 0 
    write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(2), ADDR_POS_P_GAIN, PID_values(1));
    write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(2), ADDR_POS_I_GAIN, PID_values(2));
    write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(2), ADDR_POS_D_GAIN, PID_values(3));
    
    %% Read and check if values were set correctly
    status = 0;
    
    % Check Operating Mode
    for i = 1:5
        mode = read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_PRO_OPERATING_MODE);
        if mode ~= 3
            fprintf('Operating mode not set correctly for Dynamixel %d\n', DXL_IDS(i));
            status = -1;
        end
    end
    
    % Check Drive Mode
    for i = 1:5
        mode = read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_PRO_DRIVE_MODE);
        if mode ~= drive_modes(i)
            fprintf('Drive mode not set correctly for Dynamixel %d\n', DXL_IDS(i));
            status = -1;
        end
    end
    
    % Check Homing Offset
    for i = 1:3
        offset = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_PRO_HOMING_0FFSET);
        if offset ~= homing_offsets(i)
            fprintf('Homing offset not set correctly for Dynamixel %d\n', DXL_IDS(i));
            status = -1;
        end
    end
    
    % Check Max Position Limit
    for i = 1:5
        max_pos = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_MAX_POS);
        if max_pos ~= MAX_POS(i)
            fprintf('Max position limit not set correctly for Dynamixel %d\n', DXL_IDS(i));
            status = -1;
        end
    end
    
    % Check Min Position Limit
    for i = 1:5
        min_pos = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(i), ADDR_MIN_POS);
        if min_pos ~= MIN_POS(i)
            fprintf('Min position limit not set correctly for Dynamixel %d\n', DXL_IDS(i));
            status = -1;
        end
    end
    
    % Check PID values for actuator 2
    p_gain = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(2), ADDR_POS_P_GAIN);
    i_gain = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(2), ADDR_POS_I_GAIN);
    d_gain = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_IDS(2), ADDR_POS_D_GAIN);
    if p_gain ~= PID_values(1) || i_gain ~= PID_values(2) || d_gain ~= PID_values(3)
        fprintf('PID values not set correctly for Dynamixel %d\n', DXL_IDS(2));
        status = -1;
    end
    
end
