function sat_out = sat_power(sat_in)

% sat_power
%   sat_out = sat_power(sat_in);
%
%   Function to model the CRISIS-sat power subsystem.  
%
%
%   Jared Krueger <jkrue@mit.edu>
%
%   3 Nov 2008
wgs84data;
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
global SolarFlux LightSpeed EarthMagneticMoment gravity k_Boltzmann

% -------------------------------------------------------------------------
% Model Inputs
% -------------------------------------------------------------------------
Ppeak_adcs       = sat_in.PeakPowerADCS;
Pavg_adcs        = sat_in.AvgPowerADCS;
Poff_adcs        = sat_in.OffPowerADCS;

Ppeak_payload    = sat_in.PeakPowerOptics;
Pavg_payload     = sat_in.AvgPowerOptics;
Poff_payload     = sat_in.OffPowerOptics;

Ppeak_comm       = sat_in.PeakPowerComm;
Pavg_comm        = sat_in.AvgPowerComm;
Poff_comm        = sat_in.OffPowerComm;

Ppeak_thermal    = sat_in.PeakPowerThermal;
Pavg_thermal     = sat_in.AvgPowerThermal;
Poff_thermal     = sat_in.OffPowerThermal;

Ppeak_obdh    = sat_in.PeakPowerOBDH;
Pavg_obdh     = sat_in.AvgPowerOBDH;
Poff_obdh     = sat_in.OffPowerOBDH;

Ppeak_prop    = sat_in.PeakPowerProp;
Pavg_prop     = sat_in.AvgPowerProp;
Poff_prop     = sat_in.OffPowerProp;

% orbits inputs
rho              = sat_in.Rho;
period           = sat_in.Period;           % in minutes
Life             = sat_in.Lifetime;         % in years

% -------------------------------------------------------------------------
% Subsystem power requirements
% -------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adcs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_peak_adcs = 0.15;
T_avg_adcs  = 0.60;
T_off_adcs  = 0.25;

P_adcs = T_peak_adcs * Ppeak_adcs + T_avg_adcs * Pavg_adcs + T_off_adcs * Poff_adcs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optical payload 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_peak_payload = 0.15;
T_avg_payload  = 0.60;
T_off_payload  = 0.25;

P_payload = T_peak_payload * Ppeak_payload + T_avg_payload * Pavg_payload + T_off_payload * Poff_payload;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% comm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_peak_comm = 0.15;
T_avg_comm  = 0.60;
T_off_comm  = 0.25;

P_comm = T_peak_comm * Ppeak_comm + T_avg_comm * Pavg_comm + T_off_comm * Poff_comm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBDH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_peak_obdh = 0.15;
T_avg_obdh  = 0.85;
T_off_obdh  = 0.00;

P_obdh = T_peak_obdh * Ppeak_obdh + T_avg_obdh * Pavg_obdh + T_off_obdh * Poff_obdh;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thermal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_peak_thermal = 0.00;
T_avg_thermal  = 1.00;
T_off_thermal  = 0.00;

P_thermal = T_peak_thermal * Ppeak_thermal + T_avg_thermal * Pavg_thermal + T_off_thermal * Poff_thermal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Propulsion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_peak_prop = 0.05;
T_avg_prop  = 0.05;
T_off_prop  = 0.90;

P_prop = T_peak_prop * Ppeak_prop + T_avg_prop * Pavg_prop + T_off_prop * Poff_prop;
% -------------------------------------------------------------------------
% Calculate Eclipse Time
% -------------------------------------------------------------------------

% Calculate time in daylight and eclipse
Bs  = 25*Rad;
rho = rho*Rad;
phi = 2*acos(cos(rho)/cos(Bs));
Te  = period*(phi/(2*pi));
Td  = period - Te;

% -------------------------------------------------------------------------
% Total Power Requirements
% -------------------------------------------------------------------------

% Calculate power requirements during daylight and eclipse

Pd = P_adcs + P_payload + P_comm + P_thermal + P_prop + P_obdh;
pp = 0.2; % Power consumed by the EPS = 20% of total power: SMAD page 334
Pp = Pd*pp;
Pd = Pd + Pp;
Pe = Pd;



% -------------------------------------------------------------------------
% Size solar arrays
% -------------------------------------------------------------------------
% Determine path efficiencies
Xd  = .8;
Xe  = .6;

% First estimate how much power solar arrays must produce
Psa = (Pe*Te/Xe + Pd*Td/Xd)/Td;

% Select type of solar cell and estimate size (for normal sun
% angle)
%Si = 202 W/m^2; 3.75% degradation/yr
%GaAs = 253 W/m^2; 2.75% per yr
%Multi = 301 W/m^2; 0.5% per yr

Pbol = 301*.77*cos(23.5*Rad);
Ld   = (1-.005)^Life;
Peol = Pbol*Ld;
Asa  = Psa/Peol;

% -------------------------------------------------------------------------
% Size batteries
% -------------------------------------------------------------------------
DoD = .5; %NiH2 10k cycles
N = 3;  %# of batteries
n = .9;
Cr = Pe*(Te/60)/(DoD*N*n);

% -------------------------------------------------------------------------
% Mass Estimates
% -------------------------------------------------------------------------
Msa = .04*Psa*pi;  %for cylindrical body-mounted
Mbatt = Cr/45;
Mpcu = .02*Psa;

Mpower = Msa + Mbatt + Mpcu;  % in kg

% -------------------------------------------------------------------------
% Package output sat struct
% -------------------------------------------------------------------------
sat_out = sat_in;           % copy existing fields into updated struct
sat_out.SolarArrayPower = Psa;
sat_out.SolarArrayArea = Asa;
sat_out.MassPower = Mpower;
sat_out.Power = Pd;
sat_out.PowerPower = Pp;

return;