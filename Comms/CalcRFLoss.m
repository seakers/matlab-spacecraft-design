function L = CalcRFLoss(La,Lpol,pointing_offset,beamwidth,epsmin)
% USe : L = CalcRFLoss(La,Lpol,pointing_offset,beamwidth,epsmin)
% offset, beamwidth, epsmin in deg
% freq in GHz
% La, Lpol in dB L>0
% returns L < 0 in dB

Lpol       = - Lpol;
La         = -La/cos(epsmin);
Lpoint     = -12*(pointing_offset/beamwidth).^2; % in dB
L            = Lpoint+La+Lpol;

return