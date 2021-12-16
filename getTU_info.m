function TU_info = getTU_info
%%data format: each row is a TU with coordinate x,coordinate y, service demand d and service status s
%%x,y in range(0,1); d(demand) in range(0,10); s=0(unserved),1(served)
TU_info=[
    0.1500    0.5500    7.00    0
    0.3000    0.2000    2.50    0
    0.8000    0.7000    1.32    0
    0.7500    0.8000    5.00    0
    0.4000    0.9000    3.64    0
    0.9250    0.3000    5.43    0
    ];


% TU_info=[
%     0.3000    0.7000    5.89    0
%     0.3000    0.2000    2.50    0
%     0.8000    0.7000    1.32    0
%     0.7500    0.8000    10.0    0
%     0.4350    0.2750    3.64    0
%     0.9250    0.3000    5.43    0
%     ];

end