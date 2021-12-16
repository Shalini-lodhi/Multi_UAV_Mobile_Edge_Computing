function tempA =dangerMatrix(s,E_matrix)
global N;
global K;
global M;
global TU_demand_matrix;
% A2=dangerMatrix(s,N,E_matrix,TU_demand_matrix,K,M);
% s is a random int 1*2 matrx range(0,N) as a random start point
% for each s, need to calculate weight from all points in N*N matrix to s based on E risk matrx and TU service demand
%% calculate G
N2=size(E_matrix,1);
stepdis=1/N2;
tempA=zeros(N,N);
for x1=1:N  %s1 as s, s2 as all points (x1,y1) in N*N matrix, then transfer s1 and s2 into 1*1 matrix standard
    for y1=1:N
        s1=s/N;
        s2=[x1/N,y1/N];
        delta=0;  % delta is integral risk, initial value is 0
        dis=norm(s1-s2);
        tempA(x1,y1)=dis;
        while dis>0.000001 % integration process
            [s1,dismove]=nextstep(s1,s2,stepdis);
            dis=dis-dismove;
            delta=delta+dismove*E_matrix(ceil(s1(1)*N2),ceil(s1(2)*N2));
        end
        % generate weight matrix and assign to tempA,return
        % tempA(x1,y1)=K*delta-(M*TU_demand_matrix(ceil(x1*N2/N),ceil(y1*N2/N)))+tempA(x1,y1);
        tempA(x1,y1) = K*delta+M/(1+TU_demand_matrix(ceil(x1*N2/N),ceil(y1*N2/N)))+tempA(x1,y1);
    end
end
end