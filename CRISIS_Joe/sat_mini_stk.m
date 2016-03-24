function [sat_out] = sat_mini_stk(sat_in, conid)
%% sat_mini_stk.m
% Usage : sat = sat_mini_stk(sat)
% This function calls STK in order to calculate access duration in the in 
% Theater scenario. This number is needed later for the communication module.
% Since in the In Theater scenario the target could be anywhere, access 
% duration is estimated using a fix ground station in Louisiana.



% Constants
dtr     = pi/180;
Re      = 6378;                         % Radius of the Earth in km
scenario_path = '/Scenario/CRISIS/';
scenario_name = 'CRISIS';

% Inputs


inc     = sat_in.Inclination.*dtr;      % Inclination in rad
h       = sat_in.Altitude;
eta     = sat_in.MaxPointing;

% Internal calculations

% create a ground station
facility_name = 'Louisiana';
facility_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/'];
stkNewObj(scenario_path, 'Facility', facility_name);

% set location
lat_gs = 29+59/60;
lon_gs = -(90+15/60);
LLApos = [dtr*lat_gs; dtr*lon_gs];
stkSetFacPosLLA(facility_path, LLApos);

% add a sensor to the ground station
stkNewObj(facility_path, 'Sensor', 'Antenna');

% set sensor properties
fac_sensor_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/Sensor/Antenna'];
stkSetSensor(conid, fac_sensor_path, 'SimpleCone', 80);

% -------------------------------------------------------------------------
% Create constellation with nplanes separated Delta_RAAN = 180/nplanes deg  
% and nsats separated by Delta_Mean_Anom= 360/nsats deg
% -------------------------------------------------------------------------
tStart  = 0;
tStop   = 30*86400.0;
tStep   = 3.0;
semimajorAxis = (Re + h)*1000;

sat_name = 'Sat';

% Create one satellite
stkNewObj(scenario_path, 'Satellite', sat_name);
satellite_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/'];

% Assign orbit properties to the satellite
stkSetPropClassical(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], ...
    'J2Perturbation','J2000',tStart,tStop,tStep,0,semimajorAxis,0.0,inc,0.0,0,0);

% Add a sensor (payload) to the satellite
s = 1;
sensor_name = ['Sensor' num2str(s)];
stkNewObj(satellite_path, 'Sensor', sensor_name);
sensor_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' sensor_name];

% Set the satellite sensor using custom function (Rectangular)
stkSetSensor(conid,sensor_path,'Rectangular',eta,90);

% Assign ground stations as asset for  satellite's antenna
stkSetCoverageAsset(conid, sensor_path, fac_sensor_path);

call = ['Cov_RM ' sensor_path ' Access Compute "Coverage"'];
results = stkExec(conid,call);
Naccesses = size(results,1)-2;
dur_access = zeros(Naccesses,1);
for k = 1:Naccesses
    dur_access(k) = sscanf(results(k+1,:),'%*d,%*[^,],%*[^,],%f');
end

% Compute max, mean, min and total access duration for each satellite 
%mean_comm_time     = mean(dur_access);
max_comm_time      = max(dur_access);
%min_comm_time     = min(dur_access);
%total_comm_time    = sum(dur_access);

access_duration = max_comm_time;


% -------------------------------------------------------------------------
% Close all objects except the scenario
% -------------------------------------------------------------------------
objects = stkObjNames;
for i = length(objects):-1:2
    stkUnload(objects{i});
end

sat_out = sat_in;
sat_out.InTheaterAccessDuration = access_duration;

return;

% end sat_stk.m