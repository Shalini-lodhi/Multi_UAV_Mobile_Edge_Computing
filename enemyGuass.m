function [ ENEMY ] = enemyGuass
% data format: each row is an enemy with coordinate x,coordinate y, risk radius r and id
% x,y,r in range(0,1); id is 0 indicats the enemy is obstacle not UAV

ENEMY=[
    0.8750    0.0500    0.0300   0
    0.4250    0.1000    0.0450   0
    0.3000    0.2000    0.0500   0
    0.4350    0.2750    0.0500   0
    0.9250    0.3000    0.0500   0
    0.6000    0.5000    0.0550   0
    0.6750    0.6500    0.0250   0
    0.8500    0.6500    0.0250   0
    0.7500    0.8000    0.0625   0
    0.5500    0.8250    0.0500   0
    ];

%% need to add UAVs as obstacles too
UAV_info=UAV_initialize;
ENEMY=[ENEMY;UAV_info];
end