function [SatelliteInfo]=ConcurrentDesignMain()

% Add folders
addpath ADCS
addpath Comms
addpath Power
addpath Avionics
addpath Structures
addpath Thermal
addpath LV
addpath Propulsion
addpath Plotting
addpath Payload

% Initialize all the subsystems
propulsion = [];
avionics = [];
thermal = [];
structures = [];
adcs = [];
eps = [];
comms = [];

% [payload] = CreatePayload(1); % MicroMAS cubesat
[payload] = CreatePayload(2); % comms sat

% Estimated dry mass
drymass_est = 3*payload.mass;

% Initialize the following variables just to work with the first iteration of the
% tool
satelliteDenisty = 100; % Create a satellite density for calculating an initial estimate of the Inertia Matrix and Surface Area
L = 0.5*(drymass_est/satelliteDenisty)^(1/3);
structures.InertiaMatrix = zeros(3,3);
structures.InertiaMatrix(1,1) = drymass_est^(5/3)*satelliteDenisty^(-2/3)/12;
structures.InertiaMatrix(2,2) = drymass_est^(5/3)*satelliteDenisty^(-2/3)/12;
structures.InertiaMatrix(3,3) = drymass_est^(5/3)*satelliteDenisty^(-2/3)/12;

structures.SA = L^2; % Surface Area

drymass_ok = 0;

tic
time = 0;
while (time < 250) && ~drymass_ok
    
    [avionics] = structOBC(payload.dataperday,1);
    
    [comms] = comms_main(drymass_est,payload.dataperday,payload.h,payload.i,payload.lifetime);

    [eps] = power_main(payload.h,payload.lifetime,payload.power,comms.power,2,avionics.AvgPwr,drymass_est);
    
    [propulsion] = Propulsion(drymass_est,payload.h,payload.lifetime);
    
%     [adcs] = adcs_main(payload.h,payload.pointingaccuracy,structures.InertiaMatrix(2,2),structures.InertiaMatrix(3,3),structures.SA);
    
    components = [payload.comp comms.comp avionics.comp eps.comp propulsion.comp];
    
    fprintf('Performing Structures Calculations\n');
    [structures] = structures_main(components);
    
    LV = LV_selection(payload,structures);
    drymass_calc = structures.totalMass;
    
    thermal=thermal_main(drymass_calc);
    
    drymass_ok = abs(drymass_est - drymass_calc)/drymass_calc < 0.05;
    
    cost = avionics.Cost/1000 + comms.cost + eps.cost + thermal.cost; 
    
    drymass_est = drymass_calc;
    fprintf('Total mass (kg): %f\n',drymass_calc)
    time = toc;
    
end
if drymass_ok
    fprintf('Total mass (kg): %f\n',drymass_calc)
    fprintf('Total Cost (k$): %f\n',cost)
%     PlotSatellite(components,structures)
    PlotSatInfo(payload,comms,eps,avionics,thermal,structures,propulsion,LV)
end


SatelliteInfo.mass = drymass_calc;
SatelliteInfo.cost = cost;
if ~isempty(avionics)
    SatelliteInfo.avionics = avionics;
end
if ~isempty(eps)
    SatelliteInfo.eps = eps;
end
if ~isempty(comms)
    SatelliteInfo.comms = comms;
end
if ~isempty(structures)
    SatelliteInfo.structures = structures;
end
if ~isempty(thermal)
    SatelliteInfo.thermal = thermal;
end
if ~isempty(payload)
    SatelliteInfo.payload = payload;
end
if ~isempty(propulsion)
    SatelliteInfo.propulsion = propulsion;
end
if ~isempty(adcs)
    SatelliteInfo.adcs = adcs;
end






