function robot_pose = ...
    forwardKinematics(theta1, theta2, theta3, theta4, effector)
    arguments
        theta1 double
        theta2 double
        theta3 double
        theta4 double
        effector int32 = 1;
    end
    % a4 = 14; % Task 2: 13, Task 3: Pen picking: 13, Drawing: 24
    switch effector
        case 1
            a4 = 14;
        case 2
            a4 = 24; % pen
        case 3
            a4 = 14.3; % task 4 handle 
        case 4
            a4 = 17.3; % task 4 gripper
        case 5
            a4 = 22; % task 4 spatula end
        otherwise
            a4 = 14; % default value 
    end

    % Theta Values (Modify these directly)
    theta1 = deg2rad(theta1);  
    theta2 = deg2rad(theta2);
    theta3 = deg2rad(theta3);
    theta4 = deg2rad(theta4);

    % Constants 
    d1 = 7.7;
    a2 = 13;
    a3 = 12.4;
    % a4 = set above;

    % Transformation Matrices
    T = cell(1, 5);
    T{1} = [cos(theta1), -sin(theta1), 0, 0; sin(theta1), cos(theta1), 0, 0; 0, 0, 1, d1; 0, 0, 0, 1]; 
    T{2} = [cos(theta2), -sin(theta2), 0, 0; 0, 0, -1, 0; sin(theta2), cos(theta2), 0, 0; 0, 0, 0, 1];
    T{3} = [cos(theta3), -sin(theta3), 0, a2; sin(theta3), cos(theta3), 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
    T{4} = [cos(theta4), -sin(theta4), 0, a3; sin(theta4), cos(theta4), 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
    T{5} = [1, 0, 0, a4; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

    % Compute arm positions
    positions = T{1}*T{2}*T{3}*T{4}*T{5};
    phi = rad2deg(theta2 + theta3 + theta4);
    armPos = positions(1:3, end);

    robot_pose = [armPos; phi].';
end