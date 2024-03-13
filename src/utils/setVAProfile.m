function setVAProfile(velocity, accel, port_num)
    DXL_IDS = [11, 12, 13, 14, 15];
    for i = 1:5
        write4ByteTxRx(port_num, 2.0, DXL_IDS(i), 112, velocity);
        write4ByteTxRx(port_num, 2.0, DXL_IDS(i), 108, accel);
    end
end
