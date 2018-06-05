close all
startup_rvc

mdl_puma560


% TODO: 
% Create botA
% Bot properties
%   Has rotation base
%   Has 2 links
% link oder alpha A theta D r/P

ydivison = 2;

XBaseA = 0;
YBaseA = 0;
ZBaseA = 0;


XBaseB = .5;
YBaseB = .5;
ZBaseB = 0;


XBaseC = 0;
YBaseC = 1;
ZBaseC = 0;


startx = 0.25 % halfway point
starty = -0.5/ydivison
startz = 0.1 

endx = 0.25
endy = 0.5/ydivison
endz = 0.1

idle_xA = 0.3;
idle_yA = -0.1;
idle_zA = 0.3;


precision = 30;

disable_bot_B = 0; % 0 for false 1 for True

T1 = transl(0.3, -0.1, 0.3); % define the start point
T2 = transl(0.7, 0.2, -0.1); % and destination

idleA = transl(idle_xA, idle_yA, idle_zA);

P1 = transl(startx, starty, startz);
P2 = transl(endx, endy, startz);

P3 = transl(startx, (endy + YBaseB), startz);

P4 = transl(startx, (endy + YBaseC), startz);

P5 = transl(startx, (endy + YBaseB), startz);
P6 = transl(startx, (endy + YBaseB), startz);


path1_2 = ctraj(P1, P2, precision);
path2_3 = ctraj(P2, P3, precision);
path3_4 = ctraj(P3, P4, precision);
path1_3 = ctraj(P1, P3, precision);


botA = SerialLink(p560, 'name', 'Robot A', 'base', transl(XBaseA, YBaseA, ZBaseA));
botB = SerialLink(p560, 'name', 'Robot B', 'base', transl(XBaseB, YBaseB, ZBaseB));
botC = SerialLink(p560, 'name', 'Robot C', 'base', transl(XBaseC, YBaseC, ZBaseC));


a = [0 0 0 0 0 0];
w = [-.5 1 -1.5 1.5 -1 1]
botA.plot(a,'workspace', w)
hold on

botB.plot(a)
hold on

botC.plot(a)
hold on

if disable_bot_B == 0
    qA = botA.ikine6s(path1_2) 
    qB = botB.ikine6s(path2_3)
else
    qA = botA.ikine6s(path1_3) 
end

qC = botC.ikine6s(path3_4)


hold off

for i = 1:precision-1
  botA.plot(qA(i, :), 'fps', 60)
  A1 = botA.fkine(qA(i, :));
  plot_sphere(A1.t, 0.03, 'g');
end
for i = 1:precision-1
  if disable_bot_B == 0
      botB.plot(qB(i, :), 'fps', 60)
      B1 = botB.fkine(qB(i, :));
      plot_sphere(B1.t, 0.03, 'b');
  end
end
for i = 1:precision-1
  botC.plot(qC(i, :), 'fps', 60) 
  C1 = botC.fkine(qC(i, :));
  plot_sphere(C1.t, 0.03, 'y');
end
%botA.plot(qA)
%botB.plot(qB)
%botC.plot(qC)
%hold on


%qA = botA.ikine6s(T) 
%qB = botB.ikine6s(T) 

%botA.plot(qA)
%hold on 
%botB.plot(qB)
%botB.plot(qB)

hold off


