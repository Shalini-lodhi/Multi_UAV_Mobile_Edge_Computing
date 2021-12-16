% This is used to measure the path length, service rate and risk explosure for each UAVs
%% parameters
function [PL,ServiceRate,Risk]=measure
global N2; % divide [0,1]*[0,1] map into N2*N2 grid when calculating weight matrix
global UAVnum;
global traceRecord;
global TU_info;
global enemysUK2plot;
global K;
global M;

%% path length
PathLength=[];
for i=1:UAVnum
    PathLength(i)=0;
    for j=2:size(traceRecord{i},1)
        PathLength(i)=PathLength(i)+norm(traceRecord{i}(j,:)-traceRecord{i}(j-1,:));
    end    
end
PL=roundn(sum(PathLength)/UAVnum,-4);

%% service rate
Served=0;Sum=0;
TU_info_ori=getTU_info;
for i=1:size(TU_info,1)
	Served=Served+TU_info(i,3);
	Sum=Sum+TU_info_ori(i,3);
end
ServiceRate=roundn(1-Served/Sum,-4);

%% Risk
DangerMeasure=[];
E_matrix = getEmatrix(N2,enemysUK2plot);
for i=1:UAVnum
	DangerMeasure(i)=0;
	for j=1:size(traceRecord{i},1)
		DangerMeasure(i)=DangerMeasure(i)+E_matrix(round(traceRecord{i}(j,1)*N2),round(traceRecord{i}(j,2)*N2));
	end
end
Risk=roundn(sum(DangerMeasure)/UAVnum,-4);

%% print to screen
fprintf('Average path length = %.4f \n',PL);
fprintf('Service rate = %.4f \n',ServiceRate);
fprintf('Average risk = %.4f \n',Risk);

end