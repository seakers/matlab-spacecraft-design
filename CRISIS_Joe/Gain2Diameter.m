function [D,theta] = Gain2Diameter(G_dB,f_GHz,eff)
% Gain2Diameter.m
% Calculates antenna diameter from the gain given a frequency
c = 3e8;
if G_dB < 0
    G_dB = 0;
end

G_lin = dB2lin(G_dB);
lambda = c/(f_GHz*1e9);
D = sqrt((G_lin*lambda^2)/(pi^2*eff));
theta = 21/(f_GHz*D);
if theta > 180
    theta = 180;
end

return