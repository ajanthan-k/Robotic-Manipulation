function recordMotion (record_time, port_num)
%Task 4 recording
% hardcoded effector effector 3 (task 4)

% Recording parameters
recording_length = record_time; %seconds
sampling_interval = 0.1; %seconds
N_samples = recording_length/sampling_interval;
% Record thetas
theta_samples = zeros(N_samples,4);
for i = 1:N_samples
    theta_samples(i,:) = readAngles(port_num);
    pause(sampling_interval);
end

% Record positions
position_samples = zeros(size(theta_samples));
for i = 1:N_samples
    position_samples(i,:) = forwardKinematics(theta_samples(i, 1), ...
        theta_samples(i, 2), theta_samples(i, 3), theta_samples(i, 4), 3);
end

save("egg_crack.mat", "position_samples");

end
