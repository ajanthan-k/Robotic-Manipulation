function moveArc(x_centre, y_centre, z, phi, radius, angle_start, angle_end, num_points, port_num)
    % move along linearly sampled points on an arc  
    angle = linspace(angle_start, angle_end, num_points);
    x = radius*cos(angle)+x_centre;
    y = radius*sin(angle)+y_centre;
    theta_total = cell(1, num_points);
    for j = 1:num_points
        [theta_total{j}(1), theta_total{j}(2), theta_total{j}(3), theta_total{j}(4)]= inverseKinematics(x(j), y(j), z, phi);
    end
    for i = 1:num_points
        writeTargetPos(11, theta_total{i}(1), port_num);
        writeTargetPos(12, theta_total{i}(2), port_num);
        writeTargetPos(13, theta_total{i}(3), port_num);
        writeTargetPos(14, theta_total{i}(4), port_num);
        pause(0.1);
    end
end