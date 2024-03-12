% simple function to move to a given target position
function movePos(x, y, z, phi, port_num, pause_time)
    arguments
        x double
        y double
        z double
        phi double
        port_num int32
        pause_time = 1.0
    end
    % could read current position => start_pos, target_pos = end_pos
    % and do some linear interpolation? but overcomplicated for current use
    
    thetas = inverseKinematics(x, y, z, phi);

    writeTargetPos(11, thetas(1), port_num);
    writeTargetPos(12, thetas(2), port_num);
    writeTargetPos(13, thetas(3), port_num);
    writeTargetPos(14, thetas(4), port_num);
    
    pause(pause_time);

end
