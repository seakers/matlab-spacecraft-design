function [sat_out] = sat_adcs_disturbances (sat_in)
%% sat_adcs_disturbances.m
% sat = sat_adcs_disturbances(sat)
%
% Estimates the disturbance torques for the input parameters given

%%
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined


%% unpackage sat struct

Iy          = sat_in.Iyy;
Iz          = sat_in.Izz;
h           = sat_in.Altitude;
theta       = sat_in.MaxPointing;
As          = sat_in.SurfaceArea;
q           = sat_in.Reflectance;
i           = sat_in.MaxSolarAngle;
cps_cg      = sat_in.OffsetCPsolar;
cpa_cg      = sat_in.OffsetCPaero;
D           = sat_in.ResidualDipole;
Cd          = sat_in.DragCoefficient;
V           = sat_in.Velocity;
rho         = sat_in.Density;

%% Call internal functions
R = 1000*(RE+h);
[Tg] = GGDisturbanceTorque (Iy, Iz, R, theta);
[Ta] = AeroDisturbanceTorque (Cd,As,1000*V,rho,cpa_cg);
[Tsp] = SPDisturbanceTorque (As, q, i, cps_cg);
[Tm] = MFDisturbanceTorque (D,R);
Tsp = Tsp.*ones(size(Tg));
T = [Tg;Tsp;Tm;Ta];
Tmax = max(T);

%% assign model outputs
sat_out=sat_in;
sat_out.TorqueGravity   = Tg;
sat_out.TorqueMagnetic  = Tm;
sat_out.TorqueSolar     = Tsp;
sat_out.TorqueAero      = Ta;
sat_out.MaxTorque       = Tmax;

return
