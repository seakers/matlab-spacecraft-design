function sat_out = sat_cost(sat_in)
%% sat_cost.m
%sat = sat_cost(sat)
% This function estimates the cost of the mission using the CER in SMAD.
% Costs for Research-Development-Testing, the Theoretical First Unit, and the
% following units are calculated separately and added up. A learning curve
% of 95% is used for the calculation of the second and subsequent units. 
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structures_mass         = sat_in.MassStruct;                   % from 30 to 100kg
thermal_mass            = sat_in.MassThermal;                    % from 5 to 12kg
power_mass              = sat_in.MassPower;       % from 7 to 70kg
TTC_OBDH_mass           = sat_in.MassComm;       % from 3 to 30kg
ADCS_mass               = sat_in.MassADCS;      % from 1 to 25kg
dry_mass                = sat_in.Mass;
Optics_Aperture         = sat_in.Aperture;      % from 0.2 to 12m
%optical_mass           = sat_in.MassOptics;      % from 0.2 to 12m
nsats                   = sat_in.Nsats*sat_in.Nplanes;
Ntargets                = sat_in.Ntargets;
Lifetime                = sat_in.Lifetime;
NImagesPerDay           = sat_in.NImagesPerDay;
Flength                 = sat_in.Flength;
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost Estimating Relationships (in FY00k$)
% Research, Development and Testing
% These CER are taken from SMAD page 795
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Estimation of payload's cost
%Optics_cost         = 128827*Optics_Aperture^0.562; 
Optics_cost         = 0; % Taken into account in TFU cost

% Estimation of structure's cost
structure_cost      = 157*structures_mass^0.83;

% Estimation of thermal subsystem's cost
thermal_cost        = 394*thermal_mass^0.635;

% Estimation of OBDH subsystem's cost 
OBDH_cost           = 0;%(see TTC)

% Estimation of propulsion subsystem's cost
propulsion_cost     = 0;% Taken into account by TFU model

% Estimation of ADCS subsystem's cost
ADCS_cost           = 464*ADCS_mass^0.867;

% Estimation of TTC subsystem's cost
comm_cost           = 545*TTC_OBDH_mass^0.761;

% Estimation of power subsystem's cost
power_cost          = 62.7*power_mass^1.00;

% Total cost
RDT_cost = Optics_cost + structure_cost + thermal_cost + OBDH_cost + propulsion_cost + ADCS_cost + comm_cost + power_cost;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost Estimating Relationships (in FY00k$)
% Theoretical First Unit
% These CER are taken from SMAD page 796
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Estimation of payload's cost
%Optics_cost         = 51469*Optics_Aperture^0.562;
f                   = Flength;
D                   = Optics_Aperture;
Z                   = f-sqrt(f^2-0.25*D^2);
TFU_Optics_cost     = 10*8.916e7*(D^1.8)*(Z^1.04); % Cost of TFU + research = 10 times cost of 1 unit [$]
TFU_Optics_cost     = 0.001*TFU_Optics_cost;  %[k$]


% Estimation of structure's cost
structure_cost      = 13.1*structures_mass;

% Estimation of thermal subsystem's cost
thermal_cost        = 50.6*thermal_mass^0.707;

% Estimation of OBDH subsystem's cost
OBDH_cost           = 0;

% Estimation of propulsion subsystem's cost
propulsion_cost     = 65.6 + 2.19*dry_mass^1.261;

% Estimation of ADCS subsystem's cost
ADCS_cost           = 293*ADCS_mass^0.777;

% Estimation of TTC subsystem's cost
comm_cost           = 635*TTC_OBDH_mass^0.568;

% Estimation of power subsystem's cost
power_cost          = 112*power_mass^0.763;

% Total TFU cost without optics
%TFU_cost = Optics_cost + structure_cost + thermal_cost + OBDH_cost + propulsion_cost + ADCS_cost + comm_cost + power_cost;
TFU_cost = structure_cost + thermal_cost + OBDH_cost + propulsion_cost + ADCS_cost + comm_cost + power_cost;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Learning Curve %
% SMAD page 809
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = nsats;
S = 0.95;
B = 1-log(1/S)/log(2);
L = N^B;
Nunits_cost = TFU_cost*L; % TFU_Cost does not take optics cost into account because it has a different S.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optics COST %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Optics_Nunits_cost = TFU_Optics_cost + 0.1*TFU_Optics_cost*(N-1);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL COST %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Total_cost = RDT_cost + Nunits_cost + Optics_Nunits_cost;%Launch and ground stations not modeled.

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assign outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sat_out = sat_in;
sat_out.CostPerImage = Total_cost/(Lifetime*365*Ntargets*NImagesPerDay);
sat_out.Cost = Total_cost;

return
