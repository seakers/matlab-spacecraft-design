function [GdB,theta] = Diameter2Gain(D,f_GHz)
% Diameter2Gain.m
% Calculates antenna diameter from the gain given a frequency

theta = 21/(f_GHz*D);
if theta > 180
    theta = 180;
end

GdB = 44.3 - lin2dB(theta*theta);
if (GdB < 0)
    GdB = 0;
end

return