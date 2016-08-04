function [Tm] = MFDisturbanceTorque (D,R)
% Calculates the magnetic field disturbance torque as a function of:
% D the residual dipole of the s/c in A*turn*m^2
% R the orbital altitude in m
% Note : The Earth's magnetic field is estimated as B=2M/R^3 which is true
% for a polar orbit (in the equator it is B=M/R^3)
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined

MmE =  7.96e15;

B = 2*MmE*(R.^(-3));
Tm = D.*B;
