function [Ta] = AeroDisturbanceTorque (Cd,As,V,rho,cpa_cg)
% Calculates the aerodynamic disturbance torque as a function of:
% rho the atmosphere density in kg/m^3 (Not modeled as today)
% Cd the drag coefficient
% As the surface Area
% V the velocity calculated through R
% Cpa_cg the misaligmnent in m between the center of aerodynamic pressure
% and the center of gravity
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined

%V = OrbitVelocity(R,R);%a=R, r=R (assuming e=0)
%rho = Atmosphere(R);
F = 0.5.*rho.*As.*V.^2.*Cd;
Ta = F.*cpa_cg;
