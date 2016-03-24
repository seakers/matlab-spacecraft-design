function T = NoiseTemp(Tant,LrdB,FdB)
% Calculates Noise Temperature of a receiver
% Tant Antenna Temp in K
% LrdB Loss in dB, Lr>0
% FdB Noise Factor in dB

T0 = 290;
Lr = dB2lin(-LrdB);
F = dB2lin(FdB);
T = Tant + (T0*(1-Lr)/Lr + T0*(F-1)/Lr);
return