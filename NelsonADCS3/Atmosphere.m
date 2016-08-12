function rho = Atmosphere(h)
% Calculates rho in kg/m^3 as a function of h in km
rho0 = 1E-05;
H = 33.387;
h0 = 85;

rho = rho0*exp(-(h-h0)./H);