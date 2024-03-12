%% MAIN
function out_commands = Task_3(task_ID, pen_placement, current_pose)
    % NB: Assume pen_placement has y=z=0 and pen is facing towards robot
    % For this task offset is assumed negligible
    % --- Set up constants --- (all in cm)
    % Square hole number -> cm multiplier
    grid_multiplier = 2.5;
    % Pen length (end to top of cap)
    pen_length = 14;
    % Cap length
    cap_length = 4.3;
    % Length under cap to tip
    tip_length = 3;
    % Angle to horizontal of stand
    stand_angle = 60;
    % For trig
    stand_inner_radius = 0.85;
    pen_to_floor_dist = stand_inner_radius/tand(stand_angle);
    % Gripper
    open_state = 5;
    closed_state = 2;

    pen_placement = grid_multiplier * pen_placement;

    if(task_ID == "pickup")
        pen_end_position = [pen_placement(1)-((pen_to_floor_dist+pen_length)*cosd(60)), 0, ((pen_to_floor_dist+pen_length)*sind(60)),-stand_angle];
        out_commands = pickup_pen(pen_end_position, tip_length, stand_angle, current_pose, open_state, closed_state);
    elseif(task_ID == "dropoff")
        pen_cap_opening_position = [pen_placement(1)-((pen_to_floor_dist+cap_length)*cosd(60)), 0, ((pen_to_floor_dist+cap_length)*sind(60)),-stand_angle];
        out_commands = dropoff_pen(pen_cap_opening_position, tip_length, stand_angle, current_pose, open_state);
    end
end

%% Movement output functions

function out_list = pickup_pen(pen_end, tip, angle, current_pose, open_state, closed_state)
    out_list = [];
    hovering_angle = 0;
    pickup_clearance = 5;
    cap_pull_leeway = 0;
    working_height = pen_end(3)+pickup_clearance;
    % Move to working height
    out_list(end+1,:) = [current_pose(1), current_pose(2), working_height, hovering_angle];
    out_list(end+1,:) = ["gripper", open_state, 0, 0];
    % Move to pen
    out_list(end+1,:) = [pen_end(1), pen_end(2), working_height, hovering_angle];
    out_list(end+1,:) = [pen_end(1), pen_end(2), pen_end(3), -angle];
    % Grab and pull
    out_list(end+1,:) = ["gripper", closed_state, 0, 0];
    out_list(end+1,:) = [pen_end(1)-((tip+cap_pull_leeway)*cosd(angle)), pen_end(2), pen_end(3)+((tip+cap_pull_leeway)*sind(angle)), -angle];
    % Return to middle axis, ready to draw
    out_list(end+1,:) = [0, 15, working_height, hovering_angle];
end

function out_list = dropoff_pen(cap_opening, tip, angle, current_pose, open_state)
    out_list = [];
    hovering_angle = 0;
    cap_entry_leeway = 1;
    push_leeway = 0.5;
    dropoff_clearance = 5;
    working_height = cap_opening(3)+dropoff_clearance;
    % Move to working height and then to cap opening
    out_list(end+1,:) = [current_pose(1), current_pose(2), working_height, hovering_angle];
    out_list(end+1,:) = [cap_opening(1)-((tip+cap_entry_leeway)*cosd(angle)), cap_opening(2), cap_opening(3)+((tip+cap_entry_leeway)*sind(angle)), -angle];
    % Push and release
    out_list(end+1,:) = [cap_opening(1)+((tip+push_leeway)*cosd(angle)), cap_opening(2), cap_opening(3)-((tip+push_leeway)*sind(angle)), -angle];
    out_list(end+1,:) = ["gripper", open_state, 0, 0];
    % Reset
    out_list(end+1,:) = [cap_opening(1)-((tip+cap_entry_leeway)*cosd(angle)), cap_opening(2), cap_opening(3)+((tip+cap_entry_leeway)*sind(angle)), -angle];
    out_list(end+1,:) = [current_pose(1), current_pose(2), working_height, 0];
end