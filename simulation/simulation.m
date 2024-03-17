clc
close all
clear

% Under section Input, all values can be changed, change the rest of the
% code at your discretion. In the graph, T0 is the base case, each
% subsequent TX is one transformation matrix applied towards it. In the
% frames, it follows XYZ = RGB

%% Constants Set-Up

% Link Offset for z-axis (in cm)
d1 = 7.7;

% Link Length for x-axis (in cm)
a2 = 13;
a3 = 12.4;
a4 = 12.6;

%% Inputs

% 1DOF Inputs (in cm and degrees)
x1 = 0;
% y1 = a2+a4-5;
% z1 = d1+a3-5;
y1 = 30;
z1 = 2;

phi = 0;

% Square root indicators
s3PositiveRoot = false; % Set to false for negative output of square root
x2PositiveRoot = true; % Set to false for negative output of square root

% Graph Visualisers
frameScale = 5;
axisScale = 50;
removeT1 = true; % Set to false if you want to keep T1 label and frame

% Theta Display
thetaDisplay = true; % Set to false if you want to not display thetas

%% Intermediate Code for working out

% Changing phi to radians for calculations
phi = deg2rad(phi);

% Joint angles for 1DOF (in radians)
theta1 = atan2(y1, x1);

% 3DOF inputs
x2 = (x2PositiveRoot*2-1) * sqrt(x1^2+y1^2);
y2 = 0;
z2 = z1-d1;

% Intermediate calculations
c3 = ((x2-a4*cos(phi))^2 + (z2-a4*sin(phi))^2 - a3^2 - a2^2)/(2*a3*a2);

% Conditional to ensure that c3 stays in bound
if c3 > 1
    c3 = 1; 
end

% Rest of the calculations
s3 = (s3PositiveRoot*2-1) * sqrt(1-(c3^2));
xbar = x2 - (a4*cos(phi));
zbar = z2 - (a4*sin(phi));
k2 = a3*s3;
k1 = a2 + a3*c3;

% Joint angles for 3DOF (in radians)
theta2 = atan2(zbar, xbar) - atan2(k2, k1);
theta3 = atan2(s3, c3);
theta4 = phi-theta3-theta2;

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

% Display for debugging
disp("The final positions are:")
disp("       X        Y         Z")
disp(armPos')

% Theta display for debugging
if thetaDisplay
    thetaTotal = [theta1, theta2, theta3, theta4];
%     thetaTotal = [0 0 0 0];
    for i = 1:4
        currAngle = rad2deg(thetaTotal(i));
        message = sprintf('Theta %d = %.2f', i, currAngle);
        disp(message)
    end
end

% Plotting the graph itself
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