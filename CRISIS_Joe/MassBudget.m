function sat_out = MassBudget(sat_in)
%% MassBudget.m
% sat = MassBudget(sat)
% This function plots a pie chart with the mass budget of the spacecraft. 
% Calculations are exactly te hsame as in sat_mass.m
%
%% Inputs
m_ADCS = sat_in.MassADCS;
m_comm = sat_in.MassComm;
m_optics = sat_in.MassOptics;
m_power = sat_in.MassPower;
m_thermal = sat_in.MassThermal;
m_prop = sat_in.MassProp;
m_obdh = sat_in.MassOBDH;

%% Calculations
M = m_ADCS + m_comm + m_optics + m_power + m_thermal + m_prop + m_obdh;
m_struct = 0.2*M;%SMAD p 336
%m_thermal = 0.02*M;
%m_prop = 0.06*M;

M = M + m_struct;

V = 0.01*M; %SMAD p 337
I = 0.01*M^(5/3);%SMAD p 337

%% Plot

mass_budget = [m_ADCS m_comm m_optics m_power m_thermal m_prop m_struct m_obdh];
%pie3(mass_budget,{'ADCS','Comm','Optics','Power','Thermal','Propulsion','Structure','OBDH'});
pie3(mass_budget);
h = gca;
set(h,'FontSize',16);
title(['Spacecraft Mass budget: M = ' num2str(M) ' kg']);


%% Outputs
sat_out = sat_in;
sat_out.Mass = M;
sat_out.Volume = V;
sat_out.Inertia = I;
return