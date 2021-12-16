function saveData(pathLength_list,QoS_list,Risk_list,isSigmoid)
global k_list;
global m_list;
% global pathLength_list;
% global QoS_list;
% global Risk_list;

%% Organize results
K_row=repelem(k_list,length(m_list));
M_row=repmat(m_list,1,length(k_list));
data_ori=[K_row;M_row;pathLength_list;QoS_list;Risk_list];
[rowNum,colNum]=size(data_ori);
data_cell=mat2cell(data_ori,ones(rowNum,1),ones(colNum,1));
title={'K';'M';'PathLength';'QoS';'Risk'};
results=[title,data_cell];

%% Write to file
if (isSigmoid)
    filename=[datestr(now,30),'-sigmoid','.xlsx']; % get current time
else
    filename=[datestr(now,30),'-linear','.xlsx']; % get current time
end
xlswrite(filename,results);

end