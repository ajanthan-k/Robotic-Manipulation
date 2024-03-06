function thetas = readPosAll(port_num)
    
    
    DXL_IDS = [11, 12, 13, 15, 15];

    enc1 = read2ByteTxRx(port_num, 2.0, DXL_IDS(1), 132);
    enc2 = read2ByteTxRx(port_num, 2.0, DXL_IDS(2), 132);
    enc3 = read2ByteTxRx(port_num, 2.0, DXL_IDS(3), 132);
    enc4 = read2ByteTxRx(port_num, 2.0, DXL_IDS(4), 132);
%     enc5 = read2ByteTxRx(port_num, 2.0, DXL_IDS(5), 132);

    % offsets from writeTargetPos
    theta1 = encToDeg(enc1);
    theta2 = encToDeg(enc2-120);
    theta3 = encToDeg(enc3-3976);
    theta4 = encToDeg(enc4-2048);

    thetas = [theta1, theta2, theta3, theta4];

end

function angle = encToDeg(enc)
    angle = (enc / 4096) * 360;
end