function PATH = planning(i,initial_pos,E_matrix)
global TARGET;
global TU_demand_matrix;
global UAVnum;
global G;
global N;
global EPISOD_SUM;
global K;
global M;

G_ori=G; % store G

% PATH= planning(G{i},round(UAV_pos(i,:)*N),TARGET,E_matrix,TU,N,EPISOD_SUM,K,M);
%% initialize G with all elements are N^2 and target 0
% add the following lines then G will be refreshed in each planning
for j=1:UAVnum
    G{j}=ones(N,N)*N^2;
    G{j}(TARGET(1),TARGET(2))=0;
end

%% update G matrix
node=TARGET;
for t=1:EPISOD_SUM  % while in max iteration num
    % invoke dangerMatrx.m to return a weight matrix A
    A=dangerMatrix(node,E_matrix);
    G{i}=min(G{i},G{i}(node(1),node(2))+A);  % a reward matrix to update G to find most minimum element
    node=randi(N,1,2);                       %randomly find 1*2 int matrix range(0,N)
end
% every element in G is the minimum value to that position

%% calculate PATH by W
step=1;
s=initial_pos;
PATH=[];
G_tmp=G{i};
while(~isequal(s,TARGET) && step<N*2)  % continue to planning as long as UAV hasn't arrived at target or step<2N
    step=step+1;
    %% revised
    cost_add=dangerMatrix(s,E_matrix);
    W2=G_tmp+cost_add;
    [row_index,column_index]=find(W2==min(min(W2))); % find min element in W2
    % there might be 1+ minium, so use row_index(1)
    row_index=row_index(1);
    column_index=column_index(1);
    
    s=[row_index,column_index];
    G_tmp(row_index,column_index)=N^2;
    
    % prevent deadlock in PATH
    if(~isempty(PATH)&&ismember(s,PATH,'rows'))
        continue;
    else
        PATH=cat(1,PATH,s);
    end
    %% original
    %         A2=dangerMatrix(s,E_matrix);
    %         W2=G{i}+A2;
    %         W2(s(1),s(2))=abs(min(min(W2))*1.5); %make sure s value is not minimum in W2
    %         [a,b]=min(W2);                       %find min element in W2 and assign the column and row to s(1) and s(2)
    %         [~,d]=min(a);
    %         s(1)=b(d);
    %         s(2)=d;
    %         PATH=cat(1,PATH,s);                %add new s position to TRACE
    
end

G=G_ori; % restore G

end