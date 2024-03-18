% Function to write a goal position to a single actuator
function writeTargetPos(actuatorID, targetPositionRadians, port_num)
    MAX_POS = [2400, 2200, 4000, 3200, 2800];
    MIN_POS = [0, 50, 2000, 650, 1000];
    targetPositionEnc = round(radToEnc(targetPositionRadians));
    switch actuatorID
        case 12
            target = targetPositionEnc + 120;
        case 13
            target = targetPositionEnc + 4096 - 120;
        case 14
            target = targetPositionEnc + 2048;
        otherwise
            target = targetPositionEnc;
    end

     % Check if target is within allowed range
    if target < MIN_POS(actuatorID - 10) || target > MAX_POS(actuatorID - 10)
        fprintf('Warning: Actuator %d target position out of range\n', actuatorID);
        % Adjust target to within allowed range
        target = min(max(target, MIN_POS(actuatorID - 10)), MAX_POS(actuatorID - 10));
    end

    write4ByteTxRx(port_num, 2.0, actuatorID, 116, target);
end

function encoder = radToEnc(angle)
    encoder = (angle / (2*pi)) * 4096;
end
