function ConcurrentDesignMain()

% Add folders
addpath ADCS
addpath Comms
addpath Power
addpath Avionics
addpath Structures
addpath Thermal

%  Inputs
h = 800;            % Altitude
i = 100;            % Inclination
dataperday = 10e12;   % Data per day
lifetime = 6;     % Lifetime
payloadpower=1000;

% Estimated dry mass
drymass_est = 100;

drymass_ok = 0;



% Fuel Tank
fueltank(1) = struct('Name','Fuel Tank','Subsystem','Propulsion','Shape','Sphere','Mass',150,'Dim',0.4,'CG_XYZ',[],'Vertices',[],'LocationReq','Specific','Orientation',[],'Thermal',[],'InertiaMatrix',[],'RotateToSatBodyFrame', []);
tic

time = 0;

while (time < 50) && ~drymass_ok
    
    [avionics, avionics_comp] = structOBC(dataperday,1);
    
    [comms, comms_comp] = comms_main(drymass_est,dataperday,h,i,lifetime);
    
    [power, power_comp] = power_main(h,lifetime,payloadpower,comms.power,10,avionics.AvgPwr,drymass_est);
    
    components = [fueltank comms_comp avionics_comp power_comp];
    
    [drymass_calc,~] = structures_main(components);
    
    thermal=thermal_main(drymass_calc);
   
    drymass_ok = abs(drymass_est - drymass_calc)/drymass_calc < 0.05;
    
    cost = avionics.Cost/1000 + comms.cost + power.cost + thermal.cost; 
    
    drymass_est = drymass_calc;
    
    time = toc;
    
end
if drymass_ok
    fprintf('Total mass (kg): %f\n',drymass_calc)
    fprintf('Total Cost (k$): %f\n',cost)
end
end






