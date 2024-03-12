clc
close all
clear

%% Task 2
cube_starts = {[8,3],[0,9],[-6,6]};
cube_ends = {[5,5],[0,4],[-4,0]};
current_pose = [0,15,5,-90];
cube_orientations = {"away","down","towards"};
%cube_orientations = {"up","up","up"}; %for testing stacking w/o rotation

commands_2a = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
commands_2b = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
commands_2c = Task_2("c", cube_starts, cube_ends, cube_orientations, current_pose);

%% Task 3
placement = [8,0];
current_pose = [0,15,5,-90];
commands_3pickup = Task_3("pickup", placement, current_pose);
commands_3dropoff = Task_3("dropoff", placement, current_pose);
