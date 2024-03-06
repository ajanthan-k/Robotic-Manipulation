clc
close all
clear

%% Task 2
cube_starts = {[8,3],[0,9],[-6,6]};
cube_ends = {[5,5],[0,4],[-4,0]};
current_pose = [0,0,0,-90];
cube_orientations = {'away','down','away'};
%%
commands_2a = Task_2("a", cube_starts, cube_ends, cube_orientations, current_pose);
commands_2b = Task_2("b", cube_starts, cube_ends, cube_orientations, current_pose);
commands_2c = Task_2("c", cube_starts, cube_ends, cube_orientations, current_pose);

function runCommands (command_list, port_num)

    for i = 0: size(command_list)
        if (anynan(command_list(i)))
            % gripper command
            if (command_list(i,2) == 5)
                openGripper(1, 1, port_num);
            else 
                openGripper(1, 0, port_num);
            end
        else
            movePos(command_list(1), command_list(2), command_list(3), ...
                command_list(4), port_num);

        end

    end

end