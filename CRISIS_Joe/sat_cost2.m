function sat_out = sat_cost2(sat_in)
%sat = sat_cost(sat)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structures_mass         = 50;                   % from 30 to 100kg
thermal_mass            = 7;                    % from 5 to 12kg
power_mass              = 20;                   % from 7 to 70kg
%TTC_OBDH_mass           = sat_in.TTCMass;      % from 3 to 30kg
TTC_OBDH_mass           = 15;                   % from 3 to 30kg
ADCS_mass               = sat_in.ADCSMass;      % from 1 to 25kg
Optics_Aperture         = sat_in.Aperture;      % from 0.2 to 12m
nsats                   = sat_in.Nsats;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost Estimating Relationships (in FY00k$)
% Research, Development and Testing
% These CER are taken from SMAD page 795
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize
Optics_cost         = 0;
structure_cost      = 0;
thermal_cost        = 0;
OBDH_cost           = 0;
propulsion_cost     = 0;
ADCS_cost           = 0;
comm_cost           = 0;
power_cost          = 0;

% Estimation of payload's cost
Optics_cost         = 128.827*Optics_Aperture^0.562; 

% Estimation of structure's cost
structure_cost      = 157*structures_mass^0.83;

% Estimation of thermal subsystem's cost
thermal_cost        = 394*thermal_mass^0.635;

% Estimation of OBDH subsystem's cost 
OBDH_cost           = 0;%(see TTC)

% Estimation of propulsion subsystem's cost
propulsion_cost     = 0;% Not modeled.

% Estimation of ADCS subsystem's cost
ADCS_cost           = 464*ADCS_mass^0.867;

% Estimation of TTC subsystem's cost
comm_cost           = 545*TTC_OBDH_mass^0.761;

% Estimation of power subsystem's cost
power_cost          = 62.7*power_mass^1.00;

% Total cost
RDT_cost = Optics_cost + structure_cost + thermal_cost + OBDH_cost + propulsion_cost + ADCS_cost + comm_cost + power_cost;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost Estimating Relationships (in FY00k$)
% Theoretical First Unit
% These CER are taken from SMAD page 796
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize
Optics_cost         = 0;
structure_cost      = 0;
thermal_cost        = 0;
OBDH_cost           = 0;
propulsion_cost     = 0;
ADCS_cost           = 0;
comm_cost           = 0;
power_cost          = 0;

% Estimation of payload's cost
Optics_cost         = 51.469*Optics_Aperture^0.562; 

% Estimation of structure's cost
structure_cost      = 13.1*structures_mass;

% Estimation of thermal subsystem's cost
thermal_cost        = 50.6*thermal_mass^0.707;

% Estimation of OBDH subsystem's cost
OBDH_cost           = 0;

% Estimation of propulsion subsystem's cost
propulsion_cost     = 0;% Not modeled.

% Estimation of ADCS subsystem's cost
ADCS_cost           = 293*ADCS_mass^0.777;

% Estimation of TTC subsystem's cost
comm_cost           = 635*TTC_OBDH_mass^0.568;

% Estimation of power subsystem's cost
power_cost          = -926+396*power_mass^0.72;

% Total cost
TFU_cost = Optics_cost + structure_cost + thermal_cost + OBDH_cost + propulsion_cost + ADCS_cost + comm_cost + power_cost;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Learning Curve %
% SMAD page 809
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = nsats;
S = 0.95;
B = 1-log(1/S)/log(2);
L = N^B;
Nunits_cost = TFU_cost*L;


Total_cost = RDT_cost + Nunits_cost;%Launch and ground stations not modeled.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assign outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sat_out = sat_in;
sat_out.Cost = Total_cost;
return
