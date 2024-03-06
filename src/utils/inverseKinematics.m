% Function to get thetas and write to target position
function thetas = ...
    inverseKinematics(x1, y1, z1, phi, s3PositiveRoot, x2PositiveRoot)
    arguments
        x1 double
        y1 double
        z1 double
        phi double
        s3PositiveRoot = false;
        x2PositiveRoot = true;
    end
    d1 = 7.7;
    a2 = 13;
    a3 = 12.4;
    a4 = 14; % Task 2: 13, Task 3: Pen picking: 13, Drawing: 25
    phi = deg2rad(phi);
    theta1 = atan2(y1, x1);
    x2 = (x2PositiveRoot*2-1) * sqrt(x1^2+y1^2);
    z2 = z1-d1;
    c3 = ((x2-a4*cos(phi))^2 + (z2-a4*sin(phi))^2 - a3^2 - a2^2)/(2*a3*a2);
    if c3 > 1
        c3 = 1;
    end
    s3 = (s3PositiveRoot*2-1) * sqrt(1-(c3^2));
    xbar = x2 - (a4*cos(phi));
    zbar = z2 - (a4*sin(phi));
    k2 = a3*s3;
    k1 = a2 + a3*c3;
    theta2 = atan2(zbar, xbar) - atan2(k2, k1);
    theta3 = atan2(s3, c3);
    theta4 = phi-theta3-theta2;
    
    thetas = [theta1, theta2, theta3, theta4];
end