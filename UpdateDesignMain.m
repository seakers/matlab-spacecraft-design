function [SatelliteInfo]=UpdateDesignMain()

% Add folders

addpath NelsonADCS3
addpath Comms
addpath Power
addpath Avionics
addpath SamStructures
addpath thermal72816
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

%Creates array for payload information. Input numbers 1 - 4 to input
%specific mission to create spacecraft for. 1
%1 - MicroMas Cubesat , 2 - Comms satellite , 3 - SpaceX mission (not
%working) , 4 - NOAA Aqua mission (not working) 

%[mission,payload] = CreatePayload(1); 

[mission] = InputMission();
[payload] = InputPayloads();

% Estimated dry mass
drymass_est = 3.3*sum(payload.mass);

% Initialize the following variables just to work with the first iteration of the
% tool
satelliteDensity = 79; % Create a satellite density for calculating an initial estimate of the Inertia Matrix and Surface Area
L = 0.5*(drymass_est/satelliteDensity)^(1/3);
structures.InertiaMatrix = zeros(3,3);
% Initial inertia matrix assuming cube of side L 
structures.InertiaMatrix(1,1) = drymass_est^(5/3)*satelliteDensity^(-2/3)/12;
structures.InertiaMatrix(2,2) = drymass_est^(5/3)*satelliteDensity^(-2/3)/12;
structures.InertiaMatrix(3,3) = drymass_est^(5/3)*satelliteDensity^(-2/3)/12;

structures.SA = 6*L^2; % Surface Area

tic 
time = 0;
drymass_ok = 0;

while (time < 250) && ~drymass_ok
    [avionics] = structOBC(sum(payload.dataperday),1);
    
    [comms] = comms_main(drymass_est,sum(payload.dataperday),mission.alt,mission.inc,mission.life);

    [eps] = power_main(mission.alt,mission.life,sum(payload.power),comms.power,2,avionics.AvgPwr,drymass_est);
    
     if strcmp(mission.config,'Cubesat')
        propulsion.comp = [];
        propulsion.mass = 0;
        propulsion.cost = 0;
        propulsion.power = 0;
     else 
         [propulsion] = Propulsion(drymass_est,mission.alt,mission.life);
     end

    [adcs] = adcs_main(mission.alt,min(payload.pointacc), mission.slewdur, mission.slewangle, structures.InertiaMatrix(2,2),structures.InertiaMatrix(3,3),structures.SA);
    
    components = [payload.comp comms.comp avionics.comp eps.comp propulsion.comp adcs.comp];
    
    fprintf('Performing Structures Calculations\n');
    [structures] = StructuresVolumeFill(components);

    LV = LV_selection(mission,structures);
    
    [thermal,structures.components] = thermal728(structures.width,structures.width,structures.height,mission.alt,structures.stowed);
    
    drymass_calc = structures.totalMass + thermal.mass;
    
    drymass_ok = (drymass_calc-drymass_est) < -0.15;
    drymass_est = drymass_calc;
    
    cost = avionics.Cost/1000 + comms.cost + eps.cost + thermal.cost + structures.structuresCost + payload.cost + propulsion.cost + adcs.cost; 

    fprintf('Total mass (kg): %f\n',drymass_calc)
    fprintf('Total Cost (k$): %f\n',cost)
    
    time = toc;
end
%     PlotSatellite(components,structures)
    PlotSatInfo(payload,comms,eps,avionics,thermal,structures,structures.stowed,propulsion,adcs,LV)
    PlotSatInfo(payload,comms,eps,avionics,thermal,structures,structures.deploy,propulsion,adcs,LV)

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