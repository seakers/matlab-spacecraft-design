function sat_out = sat_mass(sat_in)
%% sat_mass.m
% Usage : sat = sat_mass(sat)
% This function computes the total mass of the spacecraft.
% Structural mass is assumed to be a fix percentage 20% of the total mass.
% It also estimates volume and moments of inertia from total mass using the
% relations in SMAD page 337.

% Inputs
m_ADCS = sat_in.MassADCS;
m_comm = sat_in.MassComm;
m_optics = sat_in.MassOptics;
m_power = sat_in.MassPower;
m_thermal = sat_in.MassThermal;
m_prop = sat_in.MassProp;
m_obdh = sat_in.MassOBDH;

% Calculations
M = m_ADCS + m_comm + m_optics + m_power + m_thermal + m_prop + m_obdh;
m_struct = 0.2*M;%SMAD p 336
% m_thermal = 0.02*M;
% m_prop = 0.06*M;

M = M + m_struct;

V = 0.01*M; %SMAD p 337
I = 0.01*M^(5/3);%SMAD p 337

%Outputs
sat_out = sat_in;
sat_out.Mass = M;
sat_out.Volume = V;
sat_out.Inertia = I;
sat_out.MassStruct = m_struct;
return