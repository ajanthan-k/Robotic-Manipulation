function additional_height = getAdditionalHeight(coords)
    % fix for shoulder (as distance from origin increase, starts
    % drooping from arm weight => affects z)
    % params found using desmos line fitting method detailed in report
    distance_from_robot = sqrt(coords(1)^2+coords(2)^2);
    z = coords(3);
    m = 0.0023*(z^2)-0.0354*z+0.0325;
    c = 0.022*(z^2)+0.322*z-0.1998;
    k = 8.6;
    thres = 9;
    
    if(distance_from_robot < thres)
        additional_height = 0;
    else
        %additional_height = (-1) * ((m * distance_from_robot) + c);
        additional_height = 0;
    end
end