function moveStraightLine(start_pos, end_pos, num_points, port_num, pause_time, effector)
    arguments
        start_pos (1,4) double
        end_pos (1,4) double
        num_points int32
        port_num int32
        pause_time double = 0.2
        effector int32 = 2
    end

    % move along linearly sampled points between start_pos and end_pos
    % Args:
    % start_pos = start [x,y,z,phi]
    % end_pos = end_pos [x,y,z,phi]

    x_points = linspace(start_pos(1), end_pos(1), num_points);
    y_points = linspace(start_pos(2), end_pos(2), num_points);
    z_points = linspace(start_pos(3), end_pos(3), num_points);
    phi_points = linspace(start_pos(4), end_pos(4), num_points);

    interpolated_angles = zeros(num_points, 4);
    for j = 1:num_points
        interpolated_angles(j, :) = inverseKinematics(x_points(j), y_points(j), z_points(j), phi_points(j), effector);
    end

    for i = 1:num_points
        writeTargetPos(11, interpolated_angles(i,1), port_num);
        writeTargetPos(12, interpolated_angles(i,2), port_num);
        writeTargetPos(13, interpolated_angles(i,3), port_num);
        writeTargetPos(14, interpolated_angles(i,4), port_num);
        pause(pause_time);
    end

end
