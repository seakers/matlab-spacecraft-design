function [Tg] = GGDisturbanceTorque (Iy, Iz, R, theta)
% Calculates the gravity gradient disturbance torque as a function of:
% Iy,Iz the products of inertia
% R the orbit radius
% theta: max local deviation of the z axis from the Earth-vertical in deg
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined

muE = MU*10^9;
Tg = 3/2.*muE.*(1./R.^3).*(Iz-Iy).*sin(2.*theta.*Rad);