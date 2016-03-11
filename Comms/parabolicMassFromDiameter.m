function mass = parabolicMassFromDiameter(D)
% Calculates Parabolic Antenna Mass given the diameter D
%rho: Eff. Density [kg/m^2]
%h: Paraboloid Aspect Ratio
%alpha: Support to dish mass ratio

if D<=0.5
    rho = 20;
elseif 0.5<=D&&D<=1
    rho=10;
elseif 1<=D && D<=10
    rho=5;
else
    rho=5;
end

h=0.1;
alpha=0.05;
mass = rho*pi*(D/2)^2*((1+4*h^2)^1.5-1)/(6*h^2)*(1+alpha);

return