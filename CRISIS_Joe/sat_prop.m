function [sat_out] = sat_prop(sat_in)
global RE gravity
% -------------------------------------------------------------------------
% Model Inputs
% -------------------------------------------------------------------------
h = sat_in.Altitude;
V = sat_in.Velocity;
m = sat_in.Mass;
Isp = sat_in.SpecificImpulse;

% -------------------------------------------------------------------------
% Calculations
% -------------------------------------------------------------------------
% Delta_V for deorbiting
DV = 1000*V*(1-sqrt((2*RE)/(2*RE+h))); % [m/s]

% Propellant mass
mp = m*(1-exp(-(DV/(Isp*gravity)))); % [kg]

% Mass and power (TBI!)
mass = mp + 3;
power = 0; % No power needed except for ignition.

% -------------------------------------------------------------------------
% Model Outputs
% -------------------------------------------------------------------------

sat_out = sat_in;


sat_out.MassProp            = mass;
sat_out.PeakPowerProp       = power;
sat_out.AvgPowerProp        = 0.7*power;
sat_out.OffPowerProp        = 0.2*power;
return