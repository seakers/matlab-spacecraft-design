function [Tsp] = SPDisturbanceTorque (As, q, i, cps_cg)
%% SPDisturbanceTorque.m
% Tsp = SPDisturbanceTorque(As, q, i, cps_cg)
% Calculates the solar pressure disturbance torque as a function of:
% As the surface Area of the satellite
% q the reflectance factor
% i: angle of incidence of the Sun
global Rad
%% Inputs 
FS = 1368;
c = 3e8;

%% Calculations
F = (FS/c)*As.*(1+q).*cos(i.*Rad);
Tsp = F.*cps_cg;
