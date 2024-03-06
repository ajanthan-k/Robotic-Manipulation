% Function to write goal positions to 4 actuators
function writeTargetPosAll(targetPositions, port_num)
    
    write4ByteTxRx(port_num, 2.0, 11, 116, radToEnc(targetPositions(1))); 
    write4ByteTxRx(port_num, 2.0, 12, 116, radToEnc(targetPositions(2))+120); 
    write4ByteTxRx(port_num, 2.0, 13, 116, radToEnc(targetPositions(3))+4096-120); 
    write4ByteTxRx(port_num, 2.0, 14, 116, radToEnc(targetPositions(4))+2048);  

end

function encoder = radToEnc(angle)
    encoder = (angle / (2*pi)) * 4096;
end