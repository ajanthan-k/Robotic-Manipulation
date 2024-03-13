function moveArc(x_centre, y_centre, z, phi, radius, angle_start, angle_end, num_points, port_num, pause_time, effector)
    arguments
        x_centre double
        y_centre double
        z double
        phi double
        radius double
        angle_start double
        angle_end double
        num_points int32
        port_num int32
        pause_time double = 0.1
        effector int32 = 2
    end
    % move along linearly sampled points on an arc  
    angle = linspace(angle_start, angle_end, num_points);
    x = radius*cos(angle)+x_centre;
    y = radius*sin(angle)+y_centre;

    interpolated_angles = zeros(num_points, 4);
    for j = 1:num_points
        interpolated_angles(j, :) = ...
            inverseKinematics(x(j), y(j), z, phi, effector);
    end

    for i = 1:num_points
        writeTargetPos(11, interpolated_angles(i,1), port_num);
        writeTargetPos(12, interpolated_angles(i,2), port_num);
        writeTargetPos(13, interpolated_angles(i,3), port_num);
        writeTargetPos(14, interpolated_angles(i,4), port_num);
        pause(pause_time);
    end

end
