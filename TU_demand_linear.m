function TU_demand_matrix = TU_demand_linear
%% parameters
global N2;
global TU_info;
global SERVICE_RADIS;
global n;
global B;

%% Normalize
maxDemand=max(TU_info(:,3));
minDemand=min(TU_info(:,3));
%% Calculate accumulated TU_info service demand matrix
TU_demand_matrix=zeros(N2,N2);                   %initial T as N2*N2 0 matrix
for x=1:N2                       %for point (x,y) in N2*N2, summrize demand from TU_info with in SERVICE_RADIS, return T
    for y=1:N2
        sum=0;
        for i=1:size(TU_info,1)
            if norm([x/N2,y/N2]-TU_info(i,1:2))<= SERVICE_RADIS
                sum=sum+(TU_info(i,3)-minDemand)/(maxDemand-minDemand);
            end
        end
        TU_demand_matrix(x,y)=sum;
    end
end
end