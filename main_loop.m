clc;clear;close all;
tic;
global N; %divide [0,1]*[0,1] map into N*N grid
global N2; % divide [0,1]*[0,1] map into N2*N2 grid when calculating weight matrix
global EPISOD_SUM;
global n; % parameter in sigmoid demand function
global B; % parameter in sigmoid demand function
global OBSER_RADIS; % observe radius 0<x<1
global SERVICE_RADIS; % the radius within which a TU can be served
global stepWay; % UAV one step length
global TU_info; % TUs location matrix
global TU_demand_matrix; % TUs service demand weight matrix
global k_list;
global m_list;
global K; %risk coefficient
global M; %service demand coefficient
global imgnum;
global plotFigure;

%% Customized parameters
k_list=[5];
m_list=[0.01,0.02];
isSigmoid=1; % 1-sigmoid,0-linear
plotFigure=0; % 1-Plotting,0-No plotting

%% map information
N=20;
N2=50;
EPISOD_SUM=20*N;
n=2;
B=8;

%% UAV information
OBSER_RADIS=0.2;
SERVICE_RADIS=0.2;
stepWay=0.02;

%% data recorder
pathLength_list=[];
QoS_list=[];
Risk_list=[];

%% RUN
for index1=1:length(k_list)
    for index2=1:length(m_list)
        K=k_list(index1);
        M=m_list(index2);
        
        fprintf('\nK = %.1f, M = %.3f \n',K,M);
        
        %% unit loop
        TU_info=getTU_info;
        
        if(isSigmoid==1)
            fprintf('Using sigmoid demand function.\n');
            TU_demand_matrix=TU_demand;
        else
            fprintf('Using linear demand function.\n')
            TU_demand_matrix=TU_demand_linear;
        end
        
        COUNT=zeros(1,size(TU_info,1)); % count each TU service time
        initialize;
        drawBackground;
        main_UAVs;
        
        [PL,ServiceRate,Risk]=measure;
        pathLength_list(end+1)=PL;
        QoS_list(end+1)=ServiceRate;
        Risk_list(end+1)=Risk;
        
    end
end

%% Save results
saveData(pathLength_list,QoS_list,Risk_list,isSigmoid)

toc;