function [sat_out] = sat_obdh(sat_in)
%% sat_obdh.m
% Usage : sat = sat_obdh(sat)
% This function models the On Board and Data Handling subsystem.
% The original version simply calculates data volume as the size of a single 
% multispectral image assuming the compression factor given as a parameter.
% Mass and power requirements are constant estimates independent of the
% vector design.
% -------------------------------------------------------------------------
% Model Inputs
% -------------------------------------------------------------------------

CF = sat_in.CompressionFactor;
image_size = sat_in.ImageSize;

% -------------------------------------------------------------------------
% Calculations
% -------------------------------------------------------------------------

% Data volume taking compression into account
DV = image_size/CF;

% Mass and power (TBI)
mass = 10; % 2 Proton 100k's (estimate for mass)  
power = 9; % Proton 100k Space Processor

% -------------------------------------------------------------------------
% Model Outputs
% -------------------------------------------------------------------------

sat_out = sat_in;

sat_out.DataVolume          = DV;
sat_out.MassOBDH            = mass;
sat_out.PeakPowerOBDH       = power;
sat_out.AvgPowerOBDH        = 0.7*power;
sat_out.OffPowerOBDH        = 0.2*power;
return