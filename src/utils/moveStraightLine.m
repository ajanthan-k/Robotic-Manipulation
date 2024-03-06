function moveStraightLine(start_pos, end_pos, num_points, port_num)
    % move along linearly sampled points between start_pos and end_pos
    % Args:
    % start_pos = start [x,y,z,phi]
    % end_pos = end_pos [x,y,z,phi]

    x_points = linspace(start_pos(1), end_pos(1), num_points);
    y_points = linspace(start_pos(2), end_pos(2), num_points);
    z_points = linspace(start_pos(3), end_pos(3), num_points);
    phi_points = linspace(start_pos(4), end_pos(4), num_points);
    theta_total = cell(1, numPoints);

    for j = 1:num_points
        [theta_total{j}(1), theta_total{j}(2), theta_total{j}(3), theta_total{j}(4)] = ...
            inverseKinematics(x_points(j), y_points(j), z_points(j), phi_points(j));
    end

    for i = 1:num_points
        writeTargetPos(11, theta_total{i}(1), port_num);
	    writeTargetPos(12, theta_total{i}(2), port_num);
	    writeTargetPos(13, theta_total{i}(3), port_num);
	    writeTargetPos(14, theta_total{i}(4), port_num);
		pause(0.2);
    end
end