function openGripper(state, open, port_num)
% Open / close gripper to varying levels based on state
% state is used to to define open / close for different tasks
% 1: cubes, 2: pen holding
switch state
    % cube open / close
    case 1
        if(open)
            write4ByteTxRx(port_num, 2.0, 15, 116, 1400);
            pause(0.6);
        else 
            write4ByteTxRx(port_num, 2.0, 15, 116, 2300);
            pause(1);
        end

    case 2
        if(open)
            write4ByteTxRx(port_num, 2.0, 15, 116, 1400);
            pause(0.6);
        else 
            write4ByteTxRx(port_num, 2.0, 15, 116, 2350);
            pause(1);
        end
    otherwise
            write4ByteTxRx(port_num, 2.0, 15, 116, 1400);
end