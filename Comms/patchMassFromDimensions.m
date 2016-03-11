function mass = patchMassFromDimensions(W,L)
% Calculates Patch Antenna Mass given the diameter W,L in cm
%rho: Eff. Density [kg/m^3] Alluminium
rho=2700; % density=2.7 kg/m^3

height=0.1*max(W,L);
volume=W*L*height/(100^3);
volumereal=0.5*volume; %not complete solid structure
mass=rho*volumereal;

return