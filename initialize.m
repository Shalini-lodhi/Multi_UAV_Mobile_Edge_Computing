%% parameters
global imgnum; %looping times
global N; % divide [0,1]*[0,1] map into N*N grid
global TARGET;
global UAV_info; % UAVs location matrix
global UAVnum;
global UAV_pos; % UAVi's initial position    
global SumTarget;
global needReplan;
global enemysUK;
global enemysUK2plot;
global enemysK;
global enemysSize;
global traceRecord;
global G;

%% initialize target
imgnum=0;
TARGET = round([0.95 0.95]*N);    %target position
%% initialize UAV
UAV_info = UAV_initialize;                   
UAVnum=size(UAV_info,1);
UAV_pos=[];                 
for i=1:UAVnum
    UAV_pos(i,:)=UAV_info(i,1:2);
end
needReplan=ones(1,UAVnum);      %UAVi need to replan when needReplan(i)=1
SumTarget=zeros(1,UAVnum);      %when UAVi's SumTarget(i)=1, don't need further move

%% initialize enemys
enemysUK=enemyGuass;    %Unknown obstacles(includs all UAVs) location matrix
enemysSize=size(enemysUK,1);
enemysUK2plot=enemys();        %used when drawing map

enemysK={}; % no enemy is detected initially
for i=1:UAVnum
    enemysK{i}=[];
end

%% initialize trace record
traceRecord={}; % no record of trace initially
for i=1:UAVnum
    traceRecord{i}=[];
end

%% initialize G Matrix
G={}; 
D=ones(N,N)*N^2;  %initialize D with all elements are N^2 and target 0
D(TARGET(1),TARGET(2))=0;
for i=1:UAVnum
    G{i}=[D];
end