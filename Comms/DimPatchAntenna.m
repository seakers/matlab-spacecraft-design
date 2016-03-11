function [W,L] = DimPatchAntenna(er,f_GHz)
% Calculates rectangular Patch Antenna Dimmensions to work in a frequency f
% with dielectric with constant er
%Typical er=10.2/6.8/2.33
%W: Width of the patch antenna
%L: Length of the patch antenna

% Compute W, ereff, Leff, L (in cm)
lambda_o=30.0/f_GHz;
h=0.01*lambda_o; % dielectric thickness between 0.003*lambda_o and 0.05*lambda_o
W=30.0/(2.0*f_GHz)*sqrt(2.0/(er+1.0));
ereff=(er+1.0)/2.0+(er-1)/(2.0*sqrt(1.0+12.0*h/W));
dl=0.412*h*((ereff+0.3)*(W/h+0.264))/((ereff-0.258)*(W/h+0.8));
Leff=30.0/(2.0*f_GHz*sqrt(ereff));
L=Leff-2.0*dl;

return