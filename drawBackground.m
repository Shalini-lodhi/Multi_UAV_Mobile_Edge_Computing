%% paremeters
global N2; % divide [0,1]*[0,1] map into N2*N2 grid when calculating weight matrix
global TU_info; % TUs location matrix
global UAV_info; % UAVs location matrix
global UAVnum;
global enemysUK2plot;
global traceRecord;
global TU_demand_matrix;
global TARGET;
global N;

N2=50; %divide matrix into N2*N2 grid when drawing
% TARGET2plot=[0.895,0.898];
TARGET2plot=TARGET/N;

hold on

%% draw obstacles
% E_matrix=Ematrix(N2,enemysUK2plot);
E_matrix = getEmatrix(N2,enemysUK2plot);
[X,Y]=meshgrid(linspace(0,1,N2),linspace(0,1,N2));
contour(X,Y,E_matrix','DisplayName','E');  %draw obstacles' contour line
%% draw TUs
for i=1:size(TU_info,1)
    plot(TU_info(i,1),TU_info(i,2),'ko','Color','r','LineWidth',10,'MarkerSize',TU_info(i,3)*3);
    plot(TU_info(i,1),TU_info(i,2),'+','Color','b','MarkerSize',8,'LineWidth',1.5);
end
%% draw TUs service demand matrix
for i=1:N2
	for j=1:N2
		plot(i/N2,j/N2,'ko','Color','r','LineWidth',1,'MarkerSize',TU_demand_matrix(i,j)+0.0001);
	end
end
xlabel('x');                                                                     
ylabel('y'); 
axis([ 0 1.02 0 1.02]);
set(gcf,'Position',[900 300 450 400]);

%% draw UAVs path
UAV_info = UAV_initialize;
for i=1:UAVnum
    tr=cat(1,UAV_info(i,1:2),traceRecord{i});
    trSize=size(tr,1);
    plot(tr(trSize,1),tr(trSize,2),'ko','LineWidth',1,'MarkerSize',6); %end point
    plot(tr(1,1),tr(1,2),'ko','LineWidth',2,'MarkerSize',10); %start point
    if i==1
        c='r';
    elseif i==2
        c='g';
    else
        c='b';
    end
    plot(tr(:,1),tr(:,2),'Color',c,'LineWidth',2);
    line([0.1 0.15],[0.8-i*0.06 0.8-i*0.06],'Color',c,'LineWidth',2)
    text(0.16,0.8-i*0.06,"UAV"+i); % UAV legend
end
plot(TARGET2plot(1),TARGET2plot(2),'kx','LineWidth',2,'MarkerSize',10); %target point

%% observation radius legend
line([0.1 0.3],[0.9 0.9],'LineWidth',2)
line([0.1 0.1],[0.88 0.92],'LineWidth',2)
line([0.3 0.3],[0.88 0.92],'LineWidth',2)
text(0.11,0.87,'Observation')
text(0.11,0.83,'Radius')