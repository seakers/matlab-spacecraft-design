function mass = helixMassFromDimensions(N,D,S,pa,lambda)
% Calculates helix Antenna Mass given the dimensions
densityCopper=8940; %CopperDensity=8940kg/m^3
wireD=0.05*D;
C=D*pi;
l=N*sqrt(C^2+S^2);
thickness=0.5*wireD; %reflector thickness
massReflector=((0.8*lambda)^2*(pi/4)*thickness + 0.8*lambda/2*pi*0.8*lambda*thickness)*densityCopper;
massWire=densityCopper*wireD^2*pi/4*l;
mass=massReflector+massWire;

return