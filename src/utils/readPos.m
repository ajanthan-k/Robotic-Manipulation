function pos = readPos(port_num, effector)

thetas = readAngles(port_num);
pos = forwardKinematics(thetas(1), thetas(2), thetas(3), thetas(4), effector);

end
