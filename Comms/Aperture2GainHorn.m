function GdB = Aperture2GainHorn(A,f_GHz)
% Calculates antenna Gain from the aperture diameter of a Conical Horn and
% working frequency
% G=4*pi*Aperture*eff/lambda^2

lambda = 3e8/(f_GHz*1e9);
eff=0.5; %aperture efficency
G=4*pi*A*eff/lambda^2;
GdB=lin2dB(G);


return