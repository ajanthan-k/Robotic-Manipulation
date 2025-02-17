function Task_4(port_num)

%%

working_height = 17; % assuming box is tallest thing
flip_motion = load('pancake_flip.mat').position_samples;
egg_motion = load('egg_crack.mat').position_samples;

setVAProfile(2000, 200, port_num);

%%

movePos([0, 10, 12, -90], port_num, 2.0, 3);
setVAProfile(1000, 100, port_num);

%% pick up box 
openGripper(3, 1, port_num);
movePos([18, 0, working_height, -70], port_num, 1.0, 3);
movePos([18, 0, 9, -90], port_num, 1.0, 3)
openGripper(3, 0, port_num);
pause(1);
movePos([16, 0, 20, -30], port_num, 1.0, 3);
movePos([14, 0, 24, -30], port_num, 1.0, 3);

% box to jug
setVAProfile(2000, 200, port_num); % big movement across workspace - slow down
movePos([-4, 4, 24, -30], port_num, 1.0, 3);
movePos([-15, 15, 20, -30], port_num, 2, 3);
movePos([-19, 19, 21, -30], port_num, 1.0, 3);
setVAProfile(1000, 200, port_num);
movePos([-21, 21, 19, 0], port_num, 1.0, 3);
movePos([-21, 21, 20, 10], port_num, 1.0, 3);
pause(2); % tip
movePos([-19, 19, 21, -30], port_num, 1.0, 3);
movePos([-15, 15, 20, -30], port_num, 1.0, 3);
movePos([-4, 4, 24, -30], port_num, 1.0, 3);

% return box
setVAProfile(2000, 200, port_num);
movePos([14, 0, 24, -30], port_num, 1.0, 3);
movePos([18, 0, 18, -30], port_num, 2.0, 3);
setVAProfile(1000, 200, port_num);
movePos([16, 0, 14, -70], port_num, 1.0, 3)
movePos([17, 0, 9, -90], port_num, 1.0, 3)
openGripper(3, 1, port_num);
pause(1);
movePos([16, 0, working_height, -70], port_num, 1.0, 3); % position above box ready to move on


%% pick up egg 
openGripper(4, 1, port_num);
setVAProfile(2000, 200, port_num);
movePos([-18, 0, working_height, -70], port_num, 1.0, 3); 
movePos([-18, 0, 12, -60], port_num, 2, 3); % swing round to above egg
setVAProfile(1000, 200, port_num);
movePos([-18, 0, 8, -60], port_num, 1.0, 3); % egg pick up
openGripper(4, 0, port_num);
pause(1);
movePos([-18, 0, 12, -55], port_num, 1, 3);
movePos([-18, 0, 15, 0], port_num, 1, 3);

% crack egg over jug
% move near jug
% smack vertically against jug edge? - which should "open" egg
movePos([-14.8, 14.8, 17, -3], port_num, 1.0, 3);

%
numberOfCracks = 2;
jugHeight = 15;
for i = 1:numberOfCracks
    movePos([-20, 24, jugHeight+5, 10], port_num, 1, 3);
    setVAProfile(200, 100, port_num);
    movePos([-21, 24, jugHeight+1.5, -10], port_num, 1, 3);
    setVAProfile(1000, 200, port_num);
end
% Pull back to open egg halves then raise again
movePos([-17, 20, jugHeight+1.5, 0], port_num, 1, 3);
pause(2);
movePos([-15.1, 15.1, jugHeight+5, 0], port_num, 1, 3);

% Recorded egg motion; if doesn't work, use manual egg motion
% movePos(egg_motion(1, 1:4), port_num, 1, 3);
% setVAProfile(200, 20, port_num);
% for i = 1:length(egg_motion)
%     movePos([egg_motion(i,1:3), (egg_motion(i,4)+3)], port_num, 0.2, 3);
% end
% setVAProfile(1000, 200, port_num);

% drop egg
movePos([-20, 0, jugHeight+5, 0], port_num, 1, 3);
movePos([-20, 0, 15, -20], port_num, 1.0, 3);
movePos([-18, 0, 10, -55], port_num, 1.0, 3); % egg drop
openGripper(2, 1, port_num);
movePos([-15, 0, working_height, -5], port_num, 1.0, 3);

%% pick up spatula + bring to jug
setVAProfile(2000, 200, port_num);
movePos([15.8, 17, working_height, -5], port_num, 2, 3); % swing round to above spatula - needs to be at working height
setVAProfile(1000, 200, port_num);
movePos([15.8, 17, 7, 0], port_num, 1.0, 3); 
openGripper(3, 0, port_num);
pause(1);
movePos([14, 15, 10, 0], port_num, 1.0, 3) % pick up spatula

% bring to jug + stir 
setVAProfile(2000,100,port_num);
movePos([14, 15, 22, 0], port_num, 1.0, 3) % pick up spatula
% jug pos - z + 5, x + 4, y + 4
movePos([-17.7, 17.8, 22, 0], port_num, 2.0, 3);
% move to above jug staying horizontal
% reorient spatula to correct position within jug
movePos([-12, 12, 17, -30], port_num, 1.0, 3);

movePos([-16, 16, 17, -60], port_num, 1.0, 3);
movePos([-14.5, 16, 17, -45], port_num, 1.0, 3);
setVAProfile(30,10,port_num);
% setVAProfile(100,500,port_num); %uncomment prev line once we're sure it's safe
moveArc(-16, 16, 17, -45, 1.5, 2*pi, -2*pi, 120, port_num, 0.02, 3);

setVAProfile(1000,100,port_num);

% 
% move spatula out of jug
movePos([-12, 12, 15, -30], port_num, 1.0, 3);
movePos([-17.7, 17.8, 17, 0], port_num, 1.0, 3);
% drop off spatula
movePos([14, 15, 10, 0], port_num, 1.0, 3)
movePos([15.8, 15.8, 10, 0], port_num, 1.0, 3); 
movePos([15.8, 15.8, 7, 0], port_num, 1.0, 3);
openGripper(2, 1, port_num);
pause(0.5);
setVAProfile(500,100,port_num);
movePos([12.8, 14, 8, 0], port_num, 1.0, 3);
setVAProfile(1000,100,port_num);
movePos([12.8, 14, 16, 0], port_num, 1.0, 3);


%% Step 3: Pour batter into pan
% % pick up jug 
movePos([-13.7, 14, 16, -6], port_num, 2, 3); % move to above jug handle
movePos([-13.7, 14, 8, 0], port_num, 1.0, 3);
openGripper(3, 0, port_num);
pause(0.7);

%
% pour jug contents
movePos([-13.7, 14, 16, -6], port_num, 2, 3);
movePos([0, 14, 22, -6], port_num, 2, 3);
movePos([0, 14, 20, -50], port_num, 2, 3);
pause(1.5);
% return jug
movePos([0, 14, 22, -6], port_num, 2, 3);
movePos([-13.7, 14, 20, -6], port_num, 2, 3);
movePos([-13.7, 14, 8, 0], port_num, 1.0, 3);
openGripper(3,1,port_num);
pause(0.5);
movePos([-13.7, 14, 16, -6], port_num, 2, 3);


%% Pick up pan + flip

setVAProfile(1000, 200, port_num);
openGripper(3, 1, port_num);
movePos([0, 20, 14, -8], port_num, 1, 3);
movePos([-0.2, 20.5, 3.5, -6], port_num, 1, 3);
openGripper(3, 0, port_num); %now holding pan

movePos([0, 20, 8, -8], port_num, 1, 3);
movePos(flip_motion(1, 1:4), port_num, 1, 3);
setVAProfile(100, 20, port_num);

for i = 1:length(flip_motion)
    movePos(flip_motion(i,1:4), port_num, 0.1, 3);
end

% setVAProfile(1000, 200, port_num);
% movePos(flip_motion(1, 1:4), port_num, 1, 3);
% pause(0.5);
% setVAProfile(100, 20, port_num);
% 
% for i = 1:length(flip_motion)
%     movePos(flip_motion(i,1:4), port_num, 0.1, 3);
% end

setVAProfile(1000, 200, port_num);

% Step 6: Serve - move off stove
movePos(flip_motion(1, 1:4), port_num, 1, 3);
movePos([0, 30, 20, -0], port_num, 1, 3);
movePos([0, 36, 20, -45], port_num, 1, 3);
movePos([0, 30, 20, -30], port_num, 1, 3);
pause(1)
%%

% Put pan down
movePos(flip_motion(1, 1:4), port_num, 1, 3);
movePos([0, 20, 8, -8], port_num, 1, 3);
movePos([0, 20, 4.5, -8], port_num, 1, 3);
openGripper(3, 1, port_num);
pause(0.5);
movePos([0, 20, 8, 0], port_num, 1, 3);

end
