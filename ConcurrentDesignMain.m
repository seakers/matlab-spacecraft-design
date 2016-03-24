function [avionics, comms , power, components, structures, thermal, cost]=ConcurrentDesignMain()

% Add folders
addpath ADCS
addpath Comms
addpath Power
addpath Avionics
addpath Structures
addpath Thermal

%  Inputs
h = 400;            % Altitude
i = 100;            % Inclination
dataperday = 5e9;   % Data per day
lifetime = 3;     % Lifetime
payloadpower=5;
[payload] = CreatePayload();
% Estimated dry mass
drymass_est = 3*payload.Mass;

drymass_ok = 0;


% Fuel Tank
% fueltank(1) = struct('Name','Fuel Tank','Subsystem','Propulsion','Shape','Sphere','Mass',150,'Dim',0.4,'CG_XYZ',[],'Vertices',[],'LocationReq','Specific','Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
tic

time = 0;

while (time < 250) && ~drymass_ok
    
    [avionics, avionics_comp] = structOBC(dataperday,1);
    
    [comms, comms_comp] = comms_main(drymass_est,dataperday,h,i,lifetime);

    [power, power_comp] = power_main(h,lifetime,payloadpower,comms.power,10,avionics.AvgPwr,drymass_est);
    
    components = [payload comms_comp avionics_comp power_comp];
    
    [drymass_calc,~,components,structures] = structures_main(components);
    
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
    PlotSatellite(components,structures)
end
end






