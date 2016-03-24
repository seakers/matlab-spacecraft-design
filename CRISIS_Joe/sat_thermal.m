function [sat_out] = sat_thermal(sat_in)

% -------------------------------------------------------------------------
% Model Inputs
% -------------------------------------------------------------------------

CF = sat_in.CompressionFactor;
image_size = sat_in.ImageSize;

% -------------------------------------------------------------------------
% Calculations
% -------------------------------------------------------------------------


% Mass and power (TBI!)
mass = 5;
power = 5;

% -------------------------------------------------------------------------
% Model Outputs
% -------------------------------------------------------------------------

sat_out = sat_in;


sat_out.MassThermal            = mass;
sat_out.PeakPowerThermal       = power;
sat_out.AvgPowerThermal        = 0.7*power;
sat_out.OffPowerThermal        = 0.2*power;
return