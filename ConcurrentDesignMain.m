function [avionics, comms , power, components, structures, thermal, cost]=ConcurrentDesignMain()

% Add folders
addpath ADCS
addpath Comms
addpath Power
addpath Avionics
addpath Structures
addpath Thermal
addpath LV
addpath Propulsion

%  Inputs
% h = 400;            % Altitude
% i = 100;            % Inclination
% dataperday = 5e9;   % Data per day cubesat
% dataperday=100e9;    %Large sat
% lifetime = 3;     % Lifetime
% payloadpower=5;    %cubesat
% payloadpower=1000;     %large sat

% [payload] = CreatePayload(1); % MicroMAS cubesat
[payload] = CreatePayload(2); % MicroMAS cubesat
% Estimated dry mass
drymass_est = 3*payload.mass;

drymass_ok = 0;


% Fuel Tank
% fueltank(1) = struct('Name','Fuel Tank','Subsystem','Propulsion','Shape','Sphere','Mass',150,'Dim',0.4,'CG_XYZ',[],'Vertices',[],'LocationReq','Specific','Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
tic

time = 0;

while (time < 250) && ~drymass_ok
    
    [avionics, avionics_comp] = structOBC(payload.dataperday,1);
    
    [comms, comms_comp] = comms_main(drymass_est,payload.dataperday,payload.h,payload.i,payload.lifetime);

    [power, power_comp] = power_main(payload.h,payload.lifetime,payload.power,comms.power,2,avionics.AvgPwr,drymass_est);
    
    [propulsion] = Propulsion(drymass_est,payload.h,payload.lifetime);
    
    components = [payload.comp comms_comp avionics_comp power_comp propulsion.comp];
    
    [structures] = structures_main(components);
    
    LV = LV_selection(payload,structures);
    drymass_calc = structures.totalMass;
    
    thermal=thermal_main(drymass_calc);
    
    drymass_ok = abs(drymass_est - drymass_calc)/drymass_calc < 0.05;
    
    cost = avionics.Cost/1000 + comms.cost + power.cost + thermal.cost; 
    
    drymass_est = drymass_calc;
    fprintf('Total mass (kg): %f\n',drymass_calc)
    time = toc;
    
end
if drymass_ok
    fprintf('Total mass (kg): %f\n',drymass_calc)
    fprintf('Total Cost (k$): %f\n',cost)
%     PlotSatellite(components,structures)
    PlotSatInfo(payload,comms,power,avionics,thermal,structures,propulsion)
end
end






