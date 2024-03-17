clc;
clear all;

% Constants 
d1 = 7.7;
a2 = 13;
a3 = 12.4;
a4 = 12.6;

% Graph Visualisers
frameScale = 5;
axisScale = 50;
removeT1 = true; % Set to false if you want to keep T1 label and frame

% Theta Display
thetaDisplay = true; % Set to false if you want to not display thetas

% Theta Values (Modify these directly)
theta1 = deg2rad(90);  
theta2 = deg2rad(0);
theta3 = deg2rad(-20);
theta4 = deg2rad(0);

%% 

% Transformation Matrices
T = cell(1, 5);
T{1} = [cos(theta1), -sin(theta1), 0, 0; sin(theta1), cos(theta1), 0, 0; 0, 0, 1, d1; 0, 0, 0, 1]; 
T{2} = [cos(theta2), -sin(theta2), 0, 0; 0, 0, -1, 0; sin(theta2), cos(theta2), 0, 0; 0, 0, 0, 1];
T{3} = [cos(theta3), -sin(theta3), 0, a2; sin(theta3), cos(theta3), 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
T{4} = [cos(theta4), -sin(theta4), 0, a3; sin(theta4), cos(theta4), 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
T{5} = [1, 0, 0, a4; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

% Compute arm positions
positions = cell(1, 5);
positions{1} = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1]; % Base case: T0
positions{2} = T{1};
positions{3} = T{1}*T{2};
positions{4} = T{1}*T{2}*T{3};
positions{5} = T{1}*T{2}*T{3}*T{4};
positions{6} = T{1}*T{2}*T{3}*T{4}*T{5};

%% Plotting the Robot

% Getting all of the Positions of the arms
armPos = zeros(3, 6); % Six points: Base + Four joints + End effector
for i = 1:6 % 6 positions
    armPos(:, i) = positions{i}(1:3, end);
end

figure
title('4-DOF Robot Arm');
grid on;
axis equal;
axis([-axisScale axisScale -axisScale axisScale -axisScale axisScale]);
xlabel('X');
ylabel('Y');
zlabel('Z');
view(3);
hold on;
plot3(armPos(1, :), armPos(2, :), armPos(3, :), 'k-o', 'LineWidth', 2);

% Plotting the Frames and labels
for i = 1:6

    % Conditional to remove T1 label and frame, its in flag
    if i==2 && removeT1
        continue;
    end

    % Adding labels
    label = sprintf('T%d', (i-1));
    text(armPos(1,i), armPos(2,i), armPos(3,i), label, "VerticalAlignment","top", "HorizontalAlignment","left", "Color","k","FontSize",15)

    % X-axis Frames
    xFrame = armPos(1:3,i) + frameScale*positions{i}(1:3, 1);
    plot3([armPos(1,i), xFrame(1)], [armPos(2,i), xFrame(2)], [armPos(3,i), xFrame(3)], 'g-', 'LineWidth', 2);

    % Y-axis Frames
    yFrame = armPos(1:3,i) + frameScale*positions{i}(1:3, 2);
    plot3([armPos(1,i), yFrame(1)], [armPos(2,i), yFrame(2)], [armPos(3,i), yFrame(3)], 'b-', 'LineWidth', 2);

    % Z-axis Frames
    zFrame = armPos(1:3,i) + frameScale*positions{i}(1:3, 3);
    plot3([armPos(1,i), zFrame(1)], [armPos(2,i), zFrame(2)], [armPos(3,i), zFrame(3)], 'r-', 'LineWidth', 2);
end
