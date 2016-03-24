% Plots the dependence of the Aero disturbance torque with the orbit altitude
initConstants;

%Input parameters
%rho = 1e-13;
Cd = 2.0;
As = 2;
cpa_cg = 0.2;


%X Variable: altitude
h = 1000*[100:10:1000];
R = RE+h;
rho = Atmosphere(h);
v = orbitVelocity(R,R);

Ta = AeroDisturbanceTorque (Cd,As,v,rho,cpa_cg);

semilogy(h./1000,Ta);
title(['Aerodynamic DT vs orbit altitude for Cd= ',num2str(Cd),' As= ',num2str(As),' cpa-cg= ',num2str(cpa_cg)]);
xlabel(' Orbit altitude (km)');
ylabel(' Aero Disturbance Torque (N*m)');
