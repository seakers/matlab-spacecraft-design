function PowerBudget(sat_in)
%% PowerBudget.m
% sat = PowerBudget(sat)
% This function plots a pie chart of the poewer budget of one spacecraft.
% Calculations are exactly the same as in sat_power.
%
%% Inputs
P_ADCS = sat_in.AvgPowerADCS;
P_comm = sat_in.AvgPowerComm;
P_optics = sat_in.AvgPowerOptics;
P_power = sat_in.PowerPower;
P_thermal = sat_in.AvgPowerThermal;
P_prop = sat_in.AvgPowerProp;
P_obdh = sat_in.AvgPowerOBDH;

%% Calculations
P = P_ADCS + P_comm + P_optics + P_power + P_thermal + P_prop + P_obdh;

%% Plot

power_budget = [P_ADCS P_comm P_optics P_power P_thermal P_prop P_obdh];
%pie3(power_budget,{'ADCS','Comm','Optics','Power','Thermal','Propulsion','OBDH'});
pie3(power_budget);
title(['Spacecraft Power budget, P = ' num2str(P) ' W']);

return