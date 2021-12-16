function [s3,dis] = nextstep(s1,s2,dis0)   
%%s1,s2 is in 1*1 matrx,dis0 is one stepway

dis=norm(s1-s2);                                
if dis0>dis                      %if dis<stepway: move to s2 directly,return s2 and dis=dis(s1,s2);
    s3=s2;
else                             %else: move one step toward s2 direction, return new position and dis is one stepway
    s3=s1+(s2-s1)*dis0/dis;  
    dis=dis0;
end
end

