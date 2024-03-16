% simple function to move to a given target position
function movePos(pos, port_num, pause_time, effector)
    arguments
        pos (1,4) double
        port_num int32
        pause_time = 1.0
        effector int32 = 1
    end
    % could read current position => start_pos, target_pos = end_pos
    % and do some linear interpolation? but overcomplicated for current use
    
    thetas = inverseKinematics(pos(1), pos(2), pos(3), pos(4), effector);

    if (thetas(1) < 0)
        thetas(1) = thetas(1) + (2 * pi);
    end

    writeTargetPos(11, thetas(1), port_num);
    writeTargetPos(12, thetas(2), port_num);
    writeTargetPos(13, thetas(3), port_num);
    writeTargetPos(14, thetas(4), port_num);
    
    pause(pause_time);

end
