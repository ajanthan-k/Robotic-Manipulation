function additional_height = getAdditionalHeight(coords)
    % fix for shoulder (as distance from origin increase, starts
    % drooping from arm weight => affects z)
    % params found using desmos line fitting method detailed in report
    m = 0.08;
    c = 9.5;
    k = 8.6;
    thres = 9;
    distance_from_robot = sqrt(coords(1)^2+coords(2)^2);
    if(distance_from_robot < thres)
        additional_height = 0;
    else
        additional_height = (distance_from_robot * m) - (c-k);
    end
end