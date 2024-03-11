%% MAIN FUNC
function out_commands = Task_2(task_ID, cube_starts, cube_ends, cube_orientations, current_pose)
    % --- Set up constants ---
    % Square hole number -> cm multiplier
    grid_multiplier = 2.5;
    % Cube side length
    cube_length = 2.5;
    % Height above cube top for gripper to not collide
    cube_clearance = cube_length/2 + 2;
    % Height of cube stands
    stand_height = 2;
    % Gripper percentage to grip and drop cubes
    open_state = 2*cube_length;
    closed_state = cube_length;

    out_commands = [];
    if(task_ID == 'a')
        % 2a
        out_commands = move_cubes(coords_to_cm(cube_starts, grid_multiplier, stand_height), coords_to_cm(cube_ends, grid_multiplier, stand_height), cube_clearance, open_state, closed_state, current_pose);
    elseif (task_ID == 'b')
        % 2b
        out_commands = rotate_cubes(coords_to_cm(cube_starts, grid_multiplier, stand_height),cube_orientations, cube_clearance, open_state, closed_state, current_pose);
    else
        % 2c
        out_commands = rotate_cubes(coords_to_cm(cube_starts, grid_multiplier, stand_height),cube_orientations, cube_clearance, open_state, closed_state, current_pose);
        for i = 1:numel(cube_ends)
            curr_end = cube_ends{i};
            cube_ends{i} = [curr_end(1), curr_end(2), (stand_height+((i+0.5)*cube_length))];
        end
        tmp = move_cubes(coords_to_cm(cube_starts, grid_multiplier, stand_height), coords_to_cm(cube_ends, grid_multiplier, stand_height), cube_clearance, open_state, closed_state, current_pose);
        out_commands = [out_commands; tmp];
    end
end

%% REPOSITION

function out_list= move_cubes(C_pos_list, E_pos_list, cube_clearance, open_state, closed_state, current_pose)
    % C_pos_list and E_pos_list have corresponding indexes
    % (i.e. C1 -> E1 will both be at index 1)
    % Each position must have values [x y z phi] in cm
    out_list = [];
    % change this to be closer to 0 if required
    hovering_angle = -90;

    prev_additional_height_E = 0;
    for i = 1:numel(C_pos_list)
        C_pos = C_pos_list{i};
        E_pos = E_pos_list{i};
        
        working_height = E_pos(3)+cube_clearance;

        % fix for shoulder (as distance from origin increase, starts
        % drooping from arm weight => affects z)
        % params found using desmos line fitting method detailed in report
        m = 0.08;
        c = 9.5;
        k=8.6;
        additional_height_C = (sqrt(C_pos(1)^2+C_pos(2)^2) * m) - (c-k);
        additional_height_E = (sqrt(E_pos(1)^2+E_pos(2)^2) * m) - (c-k);

        % Move to working height, open gripper if first run, and move to cube
        out_list(end+1,:) = [current_pose(1),current_pose(2),working_height+prev_additional_height_E,hovering_angle];
        if (i==1)
            out_list(end+1,:) = ["gripper", open_state, 0, 0];
        end
        out_list(end+1,:) = [C_pos(1),C_pos(2),working_height+additional_height_C,hovering_angle];
        
        % Pick up cube
        out_list(end+1,:) = [C_pos(1),C_pos(2),C_pos(3)+additional_height_C,-90];
        out_list(end+1,:) = ["gripper", closed_state, 0, 0];
        out_list(end+1,:) = [C_pos(1),C_pos(2),working_height+additional_height_C,hovering_angle];

        % Move to end position and place cube
        out_list(end+1,:) = [E_pos(1),E_pos(2),working_height+additional_height_E,hovering_angle];
        out_list(end+1,:) = [E_pos(1),E_pos(2),E_pos(3)+additional_height_E,-90];
        out_list(end+1,:) = ["gripper", open_state, 0, 0];
        current_pose = [E_pos(1),E_pos(2),E_pos(3)+additional_height_E,-90];
        prev_additional_height_E = additional_height_E;
    end

    % Finished placing cubes, reset
    out_list(end+1,:) = [E_pos(1),E_pos(2),working_height,hovering_angle];
end

%% REORIENT

function out_list = rotate_cubes(C_pos_list, C_ori_list, cube_clearance, open_state, closed_state, current_pose)
    out_list = [];
    % All cubes should have same height when rotating
    working_height = C_pos_list{1}(3) + 2*cube_clearance;

    % fix for shoulder (as distance from origin increase, starts
    % drooping from arm weight => effects z)
    m = 0.08;
    c = 9.5;
    k=8.6;
    
    % Select one cube at a time
    for i = 1:numel(C_pos_list)
        C_pos = C_pos_list{i};
        C_ori = C_ori_list{i};
        
        needs_rotation = true;
        next_phi = -90;
        rotations = 1;

        switch C_ori
            case 'up'
                needs_rotation = false;
            case 'away'
                next_phi = -90;
                rotations = 1;
            case 'towards'
                next_phi = 0;
                rotations = -1;
            case 'down'
                next_phi = -90;
                rotations = 2;
            otherwise
                needs_rotation = false;
        end
        
        % Rotate the cube
        if needs_rotation
            % Open gripper, move to working height, and move to cube
            out_list(end+1,:) = ["gripper", open_state, 0, 0];
            out_list(end+1,:) = [current_pose(1),current_pose(2),working_height,-90];
            out_list(end+1,:) = [C_pos(1),C_pos(2),working_height,-90];
            out_list(end+1,:) = [C_pos(1),C_pos(2),working_height,next_phi];

            for j = 1:abs(rotations)
                additional_height = (sqrt(C_pos(1)^2+C_pos(2)^2) * m) - (c-k);
                out_list(end+1,:) = [C_pos(1),C_pos(2),C_pos(3)+additional_height,next_phi];
                out_list(end+1,:) = ["gripper", closed_state, 0, 0];
                out_list(end+1,:) = [C_pos(1),C_pos(2),working_height+cube_clearance,next_phi];
                out_list(end+1,:) = [C_pos(1),C_pos(2),working_height,next_phi+(sign(rotations)*90)];
                out_list(end+1,:) = [C_pos(1),C_pos(2),C_pos(3)+additional_height,(next_phi+(sign(rotations)*90))];
                out_list(end+1,:) = ["gripper", open_state, 0, 0];
                out_list(end+1,:) = [C_pos(1),C_pos(2),working_height,(next_phi+(sign(rotations)*90))];
            end
            out_list(end+1,:) = [C_pos(1),C_pos(2),working_height,-90];
            current_pose = [C_pos(1),C_pos(2),working_height,-90];
        end 
    end

    % Finished placing cubes, reset
    out_list(end+1,:) = [C_pos(1),C_pos(2),working_height,-90];
end

%% Helper functions

function cm_list = coords_to_cm(coord_list, grid_multiplier, stand_height)
    cm_list = cell(size(coord_list));
    for i = 1:numel(coord_list)
        coordinates = coord_list{i};
        % Unless the coordinates are already 3d, make them 3d
        if (numel(coordinates) ~= 3)
            coordinates = [coordinates(1), coordinates(2), 0.5];
        end
        offset_z = coordinates(3)*grid_multiplier + stand_height;
        cm_list{i} = [coordinates(1)*grid_multiplier, coordinates(2)*grid_multiplier, offset_z];
    end
end

function [x,y,z,phi] = get_pose()
    fprintf("Getting robot pose\n");
    x = 0;
    y = 10;
    z = 10;
    phi = -90;
end

function [] = gripper(closure)
    fprintf("Gripper space is now %f \n", closure);
    pause(0.2);
end
