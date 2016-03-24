function range = CalcRange(h_km,epsmin)
RE              = 6378;
rho             = asin(RE/(RE+h_km))*180/pi;
etamax          = asin(sin(rho*pi/180)*cos(epsmin*pi/180))*180/pi;
lambdamax       = 90 - epsmin - etamax;
Dmax            = RE*sin(lambdamax*pi/180)/sin(etamax*pi/180);
range           = 1000.*Dmax;

return
