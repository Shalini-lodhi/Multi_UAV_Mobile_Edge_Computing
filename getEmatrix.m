%%Ematrix is a risk weight matrix  
function E_matrix = getEmatrix(N2,enemyK)     %e is enemyK
eNum=size(enemyK,1);                   
E_matrix=zeros(N2,N2);                    %initial E as a N*N 0 matrix
for i=1:eNum                      
    td=zeros(N2,N2);               %initial td as a N*N 0 matrix
    for x=1:N2                    %for point (x,y) in N*N matrix, calculate dis(point,enemyi) and store in td
        for y=1:N2                 
            td(x,y)=norm([x/N2-enemyK(i,1) y/N2-enemyK(i,2)]); 
        end
    end
% caculate risk value, return E
    te=gaussmf(td,[enemyK(i,3) 0]);    
    E_matrix=1-(1-E_matrix).*(1-te);
end
end
