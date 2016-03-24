function [sat_out] = sat_comm(sat_in)

% sat_comm
%   sat = sat_comm(sat);
%
%   Function to model the CRISIS-sat TT&C system.
global RE   
global LightSpeed k_Boltzmann

% unpackage sat struct

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPLINK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%    INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EbN0_UL_t       = sat_in.ULRequiredEbN0; % Input from the required BER and modulation
Margin_UL       = sat_in.ULEbN0Margin; % Input in dB
L_Implem        = sat_in.ImplementationLoss; % Input in dB
PT_GS           = sat_in.ULTXPower; %Input in W
GT_GS           = sat_in.ULTXAntennaGain; %Input in dB
Ll_GS           = sat_in.ULTXLineLoss; %Input in dB
h               = sat_in.Altitude; % Input in km
epsmin          = sat_in.GroundAntennaMinElevation; % Input in deg
f_UL            = sat_in.ULFrequency; % Input in Hz
DT_DL           = sat_in.ULTXAntennaDiameter;
R_UL            = sat_in.ULDataRate; % Input, supposed small for uplink
offset_TXGS     = sat_in.ULTXAntennaPointingOffset;
effR_sat        = sat_in.ULRXAntennaEfficiency; 
 
% INTERNAL CALCULATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EbN0_UL       = EbN0_UL_t + Margin_UL + L_Implem;

EIRP_GS         = 10*log10(PT_GS) + GT_GS + Ll_GS;

rho             = asin(RE/(RE+h))*180/pi;
etamax          = asin(sin(rho*pi/180)*cos(epsmin*pi/180))*180/pi;
lambdamax       = 90 - epsmin - etamax;
Dmax            = RE*sin(lambdamax*pi/180)/sin(etamax*pi/180);
S               = 1000.*Dmax;
lambda_UL       = LightSpeed./f_UL; % wavelength in m
Ls              = 20*log10(lambda_UL./(4*pi.*S));

La              = -0.01; % Atmosphere Absorption Loss Estimated from the frequency through graph 13-10
La              = La/cos(epsmin);

Lpol            = -0.3; % Empirical value page 568

f_UL_GHz        = f_UL./1E9;
dtheta_TXUL     = 21./(f_UL_GHz.*DT_DL); % in deg
if dtheta_TXUL > 180
    dtheta_TXUL = 180; % omnidirectional antenna
end
LthetaTX_UL     = -12*(offset_TXGS./dtheta_TXUL).^2; % in dB

L_UL            = Ls+La+Lpol+LthetaTX_UL;

G_T_sat_dB      = EbN0_UL - EIRP_GS - L_UL - 10*log10(1/(k_Boltzmann*R_UL));

%estimation of Ts_sat following table page 558 SMAD
T0              = 290;
Tant            = T0;
Lr              = 10^(-0.5/10); % Line loss = 0.5dB see table.
F               = 10^(3/10); % Receiver noise figure = 3dB see table
TS_sat          = Tant + (T0*(1-Lr)/Lr + T0*(F-1)/Lr);

GR_sat          = G_T_sat_dB+10*log10(TS_sat); %in dB
if GR_sat < 0
    GR_sat = 0; % omnidirectional antenna
end

GR_sat_lin      = 10^(GR_sat/10);
DR_sat          = sqrt((GR_sat_lin*lambda_UL^2)/(pi^2*effR_sat));
dtheta_RXUL       = 21/(f_UL_GHz*DR_sat);
if dtheta_RXUL > 180
    dtheta_RXUL = 180; % omnidirectional antenna
end


% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sat_out = sat_in;


sat_out.ULRXAntennaGain         = GR_sat;
sat_out.ULRXAntennaDiameter     = DR_sat;
sat_out.ULRXAntennaBeamwidth    = dtheta_RXUL;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DOWNLINK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%    INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EbN0_DL_t       = sat_in.DLRequiredEbN0; % Input from the required BER and modulation
Margin_DL       = sat_in.DLEbN0Margin; % Input in dB
f_DL            = sat_in.DLFrequency;
offset_RXDL     = sat_in.DLRXAntennaPointingOffset;
DR_GS           = sat_in.DLRXAntennaDiameter;
Ll_SAT          = sat_in.DLTXLineLoss; %dB
DataVolume      = sat_in.DataVolume;
ImagesDay       = sat_in.ImagesPerDay;
% INTERNAL CALCULATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EbN0_DL       = EbN0_DL_t + Margin_DL + L_Implem;

lambda_DL       = LightSpeed./f_DL; % wavelength in m
Ls              = 20*log10(lambda_DL./(4*pi.*S));
La              = -0.01; % Atmosphere Absorption Loss Estimated from the frequency through graph 13-10
La              = La/cos(epsmin);
Lpol            = -0.3; % Empirical value page 568

f_DL_GHz        = f_DL./1E9;
dtheta_RXDL     = 21./(f_DL_GHz.*DR_GS); % in m
if dtheta_RXDL > 180
    dtheta_RXDL = 180; % omnidirectional antenna
end
LthetaRX_DL     = -12*(offset_RXDL./dtheta_RXDL).^2; % in dB
L_DL            = Ls+La+Lpol+LthetaRX_DL;

%estimation of R_DL
%R_DL            = 85E6;
R_DL            = ImagesDay.*DataVolume./120;%1 image per day times nbits per image in 2 min
%effR_DL         = sat_in.DLRXAntennaEfficiency;  

%estimation of Ts_sat following table page 558 SMAD
T0              = 290;
Tant            = 25;%see table
Lr              = 10^(-0.5/10); % Line loss = 0.5dB see table.
F               = 10^(1/10); % Receiver noise figure = 3dB see table
TR_GS          = Tant + (T0*(1-Lr)/Lr + T0*(F-1)/Lr);

%Estimation of the gain of the satellite tx antenna assuming the size of
%the transmitting antenna is the same than the size of the receiving
%antenna
DT_sat          = DR_sat;
dtheta_TXDL     = 21/(f_DL_GHz*DT_sat);
if dtheta_TXDL > 180
    dtheta_TXDL = 180; % omnidirectional antenna
end
GT_sat_dB       = 44.3 - 20*log10(dtheta_TXDL);
if GT_sat_dB < 0
    GT_sat_dB = 0; % omnidirectional antenna
end

%Estimation of the gain of the GS antenna as a function of the diameter
GR_GS           = 44.3 - 20*log10(dtheta_RXDL);
if GR_GS < 0
    GR_GS = 0; % omnidirectional antenna
end

tmp = 10*log10(k_Boltzmann.*R_DL.*TR_GS);

EIRP_sat        = EbN0_DL - L_DL - GR_GS + tmp;
PT_sat          = EIRP_sat - GT_sat_dB - Ll_SAT;


% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sat_out.DLTXAntennaGain         = GT_sat_dB;
sat_out.DLTXAntennaDiameter     = DT_sat;
sat_out.DLTXPower               = PT_sat;
sat_out.DLTXAntennaBeamwidth    = dtheta_TXDL;
sat_out.DLDataRate              = R_DL;
sat_out = sat_comm_MassPower(sat_out);

return;