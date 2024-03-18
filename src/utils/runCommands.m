function runCommands (command_list, port_num)
% parse commands: list of nx4 
% if column1 is NaN: gripper command -> 2.5: call close gripper, 5: call open gripper
% else: [x,y,z,phi]: call movePos

    for i = 1: size(command_list)
        if (isnan(command_list(i, 1)))
            % gripper command - hard coded for cubes
            if (command_list(i,2) == 5)
                openGripper(1, 1, port_num);
            else 
                openGripper(1, 0, port_num);
            end
        else
            movePos(command_list(i, 1:4), port_num, 0.8);
        end

    end

end
