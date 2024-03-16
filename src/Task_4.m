function Task_4(port_num)

%%

working_height = 17; % assuming box is tallest thing
flip_motion = load('pancake_flip.mat').position_samples;
egg_motion = load('egg_crack.mat').position_samples;

setVAProfile(1000, 200, port_num);

%%

movePos([0, 10, 10, -90], port_num, 1.0, 3);

%% pick up box 
openGripper(3, 1, port_num);
movePos([18, 0, working_height, -70], port_num, 1.0, 3);
movePos([18, 0, 9, -90], port_num, 1.0, 3)
openGripper(3, 0, port_num);
pause(1);
movePos([16, 0, 20, -30], port_num, 1.0, 3);

%% box to jug
setVAProfile(2000, 200, port_num); % big movement across workspace - slow down
movePos([-15, 15, 20, -30], port_num, 2, 3);
movePos([-19, 19, 21, -30], port_num, 1.0, 3);
setVAProfile(1000, 200, port_num);
movePos([-21, 21, 19, 0], port_num, 1.0, 3);
pause(2); % tip
movePos([-19, 19, 21, -30], port_num, 1.0, 3);
movePos([-15, 15, 20, -30], port_num, 1.0, 3);

%% return box
setVAProfile(2000, 200, port_num);
movePos([18, 0, 18, -30], port_num, 2.0, 3);
setVAProfile(1000, 200, port_num);
movePos([18, 0, 14, -70], port_num, 1.0, 3)
movePos([18, 0, 9, -90], port_num, 1.0, 3)
openGripper(3, 1, port_num);
pause(1);
movePos([16, 0, working_height, -70], port_num, 1.0, 3); % position above box ready to move on


%% pick up egg 
openGripper(4, 1, port_num);
setVAProfile(2000, 200, port_num);
movePos([-18, 0, working_height, -70], port_num, 1.0, 3); 
movePos([-18, 0, 12, -55], port_num, 2, 3); % swing round to above egg
setVAProfile(1000, 200, port_num);
movePos([-18, 0, 8, -55], port_num, 1.0, 3); % egg pick up
openGripper(4, 0, port_num);
pause(1);
movePos([-18, 0, 12, -55], port_num, 1, 3);
movePos([-18, 0, 15, 0], port_num, 1, 3);

%% crack egg over jug
% move near jug
% smack vertically against jug edge? - which should "open" egg
movePos([-14.8, 14.8, 17, -3], port_num, 1.0, 3);

%%
movePos(egg_motion(1, 1:4), port_num, 1, 3);
setVAProfile(200, 20, port_num);
for i = 1:length(egg_motion)
    movePos([egg_motion(i,1:3), (egg_motion(i,4)+(8*i/60))], port_num, 0.2, 3);
end
setVAProfile(1000, 200, port_num);

%%
movePos([-20, 0, 15, -20], port_num, 1.0, 3);
openGripper(2, 1, port_num);

%% pick up spatula + bring to jug
setVAProfile(2000, 200, port_num);
movePos([15.8, 17, 18, -5], port_num, 2, 3); % swing round to above spatula - needs to be at working height
setVAProfile(1000, 200, port_num);
movePos([15.8, 17, 6.5, -5], port_num, 1.0, 3); 
openGripper(3, 0, port_num);
pause(1);
movePos([14, 15, 10, 0], port_num, 1.0, 3) % pick up spatula

%% bring to jug + stir 
setVAProfile(2000,100,port_num);
movePos([14, 15, 22, 0], port_num, 1.0, 3) % pick up spatula
% jug pos - z + 5, x + 4, y + 4
movePos([-17.7, 17.8, 22, 0], port_num, 2.0, 3);
% move to above jug staying horizontal
% reorient spatula to correct position within jug
movePos([-12, 12, 15, -30], port_num, 1.0, 3);

movePos([-14.5, 14.5, 14, -60], port_num, 1.0, 3);
setVAProfile(10,5,port_num);
moveArc(-16, 16, 16, -60, 1.5, 2*pi, -4*pi, 180, port_num, 0.01, 3);

setVAProfile(1000,100,port_num);

%% 
% move spatula out of jug
movePos([-12, 12, 15, -30], port_num, 1.0, 3);
movePos([-17.7, 7.8, 17, 0], port_num, 1.0, 3);
% drop off spatula
movePos([14, 15, 10, 0], port_num, 1.0, 3)
movePos([15.8, 17, 8, -5], port_num, 1.0, 3); 
movePos([15.8, 17, 7, -5], port_num, 1.0, 3);
openGripper(2, 1, port_num);
movePos([12.8, 14, 8, -5], port_num, 1.0, 3);
movePos([12.8, 14, 16, 0], port_num, 1.0, 3);


%% Step 3: Pour batter into pan
% % pick up jug 
movePos([-13.7, 14, 16, -6], port_num, 2, 3); % move to above jug handle
movePos([-13.7, 14, 7.1, -6], port_num, 1.0, 3);
openGripper(3, 0, port_num);
pause(1);

%%
% pour jug contents
movePos([-13.7, 14, 16, -6], port_num, 2, 3);
movePos([0, 14, 22, -6], port_num, 2, 3);
movePos([0, 14, 20, -50], port_num, 2, 3);
% return jug

pause(2);

movePos([-13.7, 14, 20, -6], port_num, 2, 3);
movePos([-13.7, 14, 7.1, -6], port_num, 1.0, 3);
openGripper(3,1,port_num);

movePos([-13.7, 14, 16, -6], port_num, 2, 3);


%% Pick up pan + flip

setVAProfile(1000, 200, port_num);
openGripper(3, 1, port_num);
movePos([0, 20, 10, -8], port_num, 1, 3);
movePos([0, 20, 3.8, -8], port_num, 1, 3);
openGripper(3, 0, port_num);

%%

movePos([0, 20, 8, -8], port_num, 1, 3);
movePos(flip_motion(1, 1:4), port_num, 1, 3);
setVAProfile(100, 20, port_num);

for i = 1:length(flip_motion)
    movePos(flip_motion(i,1:4), port_num, 0.1, 3);
end

setVAProfile(1000, 200, port_num);

% Step 6: Serve - move off stove
pause(2);
movePos(flip_motion(1, 1:4), port_num, 1, 3);
movePos([flip_motion(1, (1:2)), flip_motion(1, 3)+5, -45], port_num, 1, 3);
pause(1)
movePos(flip_motion(1, 1:4), port_num, 1, 3);

end
