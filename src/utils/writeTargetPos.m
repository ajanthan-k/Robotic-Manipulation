% Function to write a goal position to a single actuator
function writeTargetPos(actuatorID, targetPositionRadians, port_num)
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
    write4ByteTxRx(port_num, 2.0, actuatorID, 116, target);
end

function encoder = radToEnc(angle)
    encoder = (angle / (2*pi)) * 4096;
end