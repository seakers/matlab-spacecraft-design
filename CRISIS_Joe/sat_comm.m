function [sat_out] = sat_comm(sat_in,conid)
%% sat_comm.m
%   sat = sat_comm(sat);
%
%   Function to model the CRISIS-sat TT&C system. The function calculates
%   both the uplink and the downlink. The uplink equation allows to
%   calculate the gain and diameter of the antenna of the satellite. The
%   downlink equation allows the estimation of the power emitted by the
%   antenna. See the code for constant values assumed for certaint
%   parameters of the equations (line losses, receiver noise temperature,
%   etc.)

%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPLINK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%    INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EbN0_UL_t           = sat_in.ULRequiredEbN0; % Input from the required BER and modulation
Margin_UL           = sat_in.ULEbN0Margin; % Input in dB
L_Implem            = sat_in.ImplementationLoss; % Input in dB
PT_GS               = sat_in.ULTXPower; %Input in W
Ll_GS               = sat_in.ULTXLineLoss; %Input in dB
h                   = sat_in.Altitude; % Input in km
epsmin              = sat_in.GroundAntennaMinElevation; % Input in deg
f_UL                = sat_in.ULFrequency; % Input in Hz
DT_UL               = sat_in.ULTXAntennaDiameter;
R_UL                = sat_in.ULDataRate; % Input, supposed small for uplink
offset_TXGS         = sat_in.ULTXAntennaPointingOffset;
effR_sat            = sat_in.ULRXAntennaEfficiency; 
 
% INTERNAL CALCULATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_UL_GHz            = f_UL./1E9;
[dtheta_TXUL,null]  = Diameter2Gain(DT_UL,f_UL_GHz); % in deg
L_UL                = CalcRFLoss(0.01,0.3,offset_TXGS,dtheta_TXUL,epsmin);
T                   = NoiseTemp(290,0.5,3);
PtdB                = lin2dB(PT_GS);
GR_sat              = RFLink('Gr/Dr','Margin',Margin_UL,'Dt',DT_UL,'Pt',PtdB,'f',f_UL,'L',L_UL,'h',h,'T',T,'Rb',R_UL,'Eb/N0_min',EbN0_UL_t,'L_Impl',L_Implem,'eps_min',epsmin);
[DR_sat,dtheta_RXUL]= Gain2Diameter(GR_sat,f_UL_GHz,effR_sat);

% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sat_out = sat_in;
sat_out.ULRXAntennaGain         = GR_sat;
sat_out.ULRXAntennaDiameter     = DR_sat;
sat_out.ULRXAntennaBeamwidth    = dtheta_RXUL;

%%
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
%ImagesDay       = sat_in.ImagesPerDay;
%R_DL            = sat_in.DLDataRate;
access_duration = sat_in.InTheaterAccessDuration;

% INTERNAL CALCULATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M                       = 2;   %SMAD page 546
Ti                      = 120; %SMAD page 546
if access_duration > 120 
    R_DL  = M*DataVolume./(access_duration-Ti);%download one image in half of the access duration
else
    R_DL = M*DataVolume./(access_duration);%No time for stablishing communication
    disp('[sat_comm] Warning: Access Duration for in Theater Scenario < 2 min');
end

if R_DL < 1e6
    R_DL = 1e6;
end

DT_sat                  = DR_sat;
f_DL_GHz                = f_DL./1E9;
[GT_sat_dB, dtheta_TXDL]= Diameter2Gain(DT_sat,f_DL_GHz);
[G_GS, dtheta_RXDL]     = Diameter2Gain(DR_GS,f_DL_GHz); % in deg
L_DL                    = CalcRFLoss(0.01,0.3,offset_RXDL,dtheta_RXDL,epsmin);
T                       = NoiseTemp(25,0.5,1);
PtdB                    = RFLink('PtdB/PtW','Margin',Margin_DL,'Dt',DT_sat,'Dr',DR_GS,'f',f_DL,'L',L_DL,'h',h,'T',T,'Rb',R_DL,'Eb/N0_min',EbN0_DL_t,'L_Impl',L_Implem,'eps_min',epsmin);
PT_sat                  = dB2lin(PtdB);

% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sat_out.DLTXAntennaGain         = GT_sat_dB;
sat_out.DLTXAntennaDiameter     = DT_sat;
sat_out.DLTXPower               = PT_sat;
sat_out.DLTXAntennaBeamwidth    = dtheta_TXDL;
sat_out.DLDataRate              = R_DL;
sat_out.InTheaterAccessDuration = access_duration;
sat_out = sat_comm_MassPower(sat_out);
return;