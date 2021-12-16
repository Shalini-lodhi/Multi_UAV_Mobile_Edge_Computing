%% parameters
global N; %divide [0,1]*[0,1] map into N*N grid
global N2; % divide [0,1]*[0,1] map into N2*N2 grid when calculating weight matrix
global EPISOD_SUM;
global n;
global B;
global OBSER_RADIS; % observe radius 0<x<1
global SERVICE_RADIS; % the radius within which a TU can be served
global stepWay; % UAV one step length
global TU_info; % TUs location matrix
global TU_demand_matrix; % TUs service demand weight matrix
global K; %risk coefficient
global M; %service demand coefficient

global imgnum; %looping times
global TARGET;
global UAVnum;
global UAV_pos; % UAVi's initial position
global SumTarget;
global needReplan;
global enemysUK;
global enemysK;
global enemysSize;
global traceRecord;
global G;

%% UAV movement
while (sum(SumTarget)~=UAVnum) % when all UAV arrive at target, stop interation
    for i=1:UAVnum
        % if one UAV arrives at target, no further planning is needed
        if (norm(round(UAV_pos(i,:)*N)-TARGET)<=stepWay*5)
            SumTarget(i)=1;
        else
            imgnum=imgnum+1;
            
            %% delete outdated other UAVs locations in enemysK{i}
            if(~isempty(enemysK{i})) % if enemysK is not empty
                s=1;
                while(s<size(enemysK{i},1))
                    % if (the element in enemysK is a UAV && the ith UAV hasn't arrived at TARGET)
                    if(enemysK{i}(s,4)~=0 && SumTarget(i)==0)
                        enemysK{i}(s,:)=[]; % delete other UAVs from enemysK{i}
                    else
                        s=s+1;
                    end
                end
            end
            
            %% detect new obstacles and add to enemysK{i}
            j=1;
            while (j<=enemysSize)  % search all enemyUK
                % obstacles in enemyUK not UAVi and within observe radius
                if (norm(enemysUK(j,1:2)-UAV_pos(i,:))<OBSER_RADIS && enemysUK(j,4)~=i)
                    flag=0;
                    for k=1:size(enemysK{i},1) % not already in enemyK
                        if((enemysUK(j,1)==enemysK{i}(k,1) & enemysUK(j,2)==enemysK{i}(k,2) & enemysUK(j,3)==enemysK{i}(k,3) & enemysUK(j,4)==enemysK{i}(k,4))==1)
                            flag=1;
                        end
                    end
                    if(flag==0)
                        enemysK{i}=cat(1,enemysK{i},enemysUK(j,1:4));   %add new enemy
                        needReplan(i)=1;    %need to replan because of altered enemyK
                    end
                end
                j=j+1;
            end
            
            %% if a UAV arrives at TARGET, delete it as obstacles from other UAV's enemyK
            if SumTarget(1)==1
                row_index=find(enemysK{2}(:,4)==1);
                enemysK{2}(row_index,:)=[];
                row_index=find(enemysK{3}(:,4)==1);
                enemysK{3}(row_index,:)=[];
            end
            
            if SumTarget(2)==1
                row_index=find(enemysK{1}(:,4)==2);
                enemysK{1}(row_index,:)=[];
                row_index=find(enemysK{3}(:,4)==2);
                enemysK{3}(row_index,:)=[];
            end
            
            if SumTarget(3)==1
                row_index=find(enemysK{1}(:,4)==3);
                enemysK{1}(row_index,:)=[];
                row_index=find(enemysK{2}(:,4)==3);
                enemysK{2}(row_index,:)=[];
            end
            
            %% Replan and get PATH
            if(needReplan(i)==1)
                needReplan(i)=0;
                % disp("UAV"+i+':replanning...');
                % E_matrix is UAVi's risk weight matrix based on current eneymyK
                % the matrix is devided into N2*N2 grid when calculating
                E_matrix = getEmatrix(N2,enemysK{i});
                % invoke planning.m to give out new PATH for UAVi to follow
                % round£¨UAV_pos*N£©is to magnify UAV_pos into N*N grid£¬the matrix is devided into N*N grid when calculating
                PATH{i} = planning(i,round(UAV_pos(i,:)*N),E_matrix);
            end
            
            %% move one step
            if(isequal(round(UAV_pos(i,:)*N),PATH{i}(1,1:2)))
                PATH{i}(1,:)=[]; % if first line has been visited, delete first line
            end
            tgoal=PATH{i}(1,1:2)/N; % turn PATH from N*N size to 1*1 size
            dis=norm(tgoal-UAV_pos(i,:)); % calculate distance from UAV_pos to next position
            if(dis>stepWay)
                % move one step toward the tgoal direction
                UAV_pos(i,:)=UAV_pos(i,:)+(tgoal-UAV_pos(i,:))*stepWay/dis;
            else
                % move to tgoal directly
                UAV_pos(i,:)=tgoal;
            end
            
            %% update TUs demand matrix
            for k=1:size(TU_info,1)
                if(norm(TU_info(k,1:2)-UAV_pos(i,:))<=SERVICE_RADIS && TU_info(k,4)==0)  %demand matix removes all demand from unserved TUs who locate within service radius
                    f=max(0.00001,TU_info(k,3)-1);
                    for x=ceil(N2*max(1/N2,TU_info(k,1)-SERVICE_RADIS)):floor(N2*min(1,TU_info(k,1)+SERVICE_RADIS))
                        for y=ceil(N2*max(1/N2,TU_info(k,2)-SERVICE_RADIS)):floor(N2*min(1,TU_info(k,2)+SERVICE_RADIS)) % In kth TUs square range
                            if(norm([x/N2 y/N2]-TU_info(k,1:2))<=SERVICE_RADIS) % Circle the range
                                TU_demand_matrix(x,y)=max(0,TU_demand_matrix(x,y)-(1-exp(-power(TU_info(k,3),n)/(TU_info(k,3)+B)))+(1-exp(-power(f,n)/(f+B))));
                            end
                        end
                    end
                    TU_info(k,3)=f;
                    if(TU_info(k,3)<0.0001)
                        TU_info(k,4)=1;           %1 means the TU is served
                        COUNT(k)=imgnum;    %record service arrival time
                    end
                end
            end
            
            %% update UAVi's new position in enemysUK£¬traceRecord record new position
            [x3,y3]=find(enemysUK(:,4)==i);
            enemysUK(x3,1:2)=UAV_pos(i,:);
            traceRecord{i}=cat(1,traceRecord{i},UAV_pos(i,:));
        end
        if (plotFigure==1)
            % draw every 50 iterations
            if(mod(imgnum,30)==0 || imgnum==5)
                close all;
                drawBackground;
                % saveas(gcf,['K=',num2str(K),'_M=',num2str(M),'_img',num2str(imgnum)],'fig');
                savefig(['K=',num2str(K),'_M=',num2str(M),'_img',num2str(imgnum),'.fig']);
            end
        end
    end
end
if (plotFigure==1)
    close all;
    drawBackground;
    % saveas(gcf,['K=',num2str(K),'_M=',num2str(M),'_img',num2str(imgnum)],'fig');
    savefig(['K=',num2str(K),'_M=',num2str(M),'_img',num2str(imgnum),'.fig']);
end