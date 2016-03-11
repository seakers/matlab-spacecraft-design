function [N,D,S,pa,theta] = Gain2Helical(G_dB,f_GHz)
% Calculates Helical Antenna Dimmensions in axial mode(Sat Comms) from the required gain at a given frequency
%N: Number of turns
%D: Circumference diameter
%S: Separation between turns
%pa: pitch angle
c = 3e8;
lambda = c/(f_GHz*1e9);
if G_dB < 0
    G_dB = 0;
end

G_lin = dB2lin(G_dB);
D = lambda./pi;
C=D*pi;
S=lambda./4;
pa=atan(S/C);
N=G_lin*lambda.^3/(6.2*C.^2*S);
theta = 52*(lambda.^1.5)/(C*sqrt(N*S));
if theta > 180
    theta = 180;
end

return