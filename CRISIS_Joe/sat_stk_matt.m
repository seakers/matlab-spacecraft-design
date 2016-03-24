function [sat_out] = sat_stk(sat_in, conid)
% SAT_STK 
%   sat = sat_stk(sat)
% 
%   This function utilizes STK to calculate Figures of Merit such as 
%   Revisit Time, Coverage, etc. It defines a scenario with one ground 
%   station with an antenna, Nsats satellites in Nplanes, one optical 
%   sensor and one communications sensor in each satellite. It computes 
%   revisit time and time to global coverage. The outputs are copied into 
%   the satellite structure.
%
%
%   Jared Krueger <jkrue@mit.edu>
%   Daniel Selva <dselva@mit.edu>
%   Matthew Smith <m_smith@mit.edu>
%
%   1 Nov 2008


% Constants
dtr     = pi/180;
Re      = 6378;                         % Radius of the Earth in km
scenario_path = '/Scenario/CRISIS/';
scenario_name = 'CRISIS';

% Inputs
% nsats   = 3;
% nplanes = 3;
% inc     = 98*dtr;               % Inclination in rad
% h       = 567;
% angle_h = 20;                   % horizontal half angle for the optics
% angle_v = 10;                   % vertical half angle for the optics
% angle_a = 45;                   % cone angle for the S/C antenna
% n_gs    = 2;
% lat_gs  = [37.9455 21.3161];     % ground station coordinates
% lon_gs  = [-75.4611 -157.8864];
% angle_gs = 30;                    % antenna angle for the ground stations
nsats   = sat_in.Nsats;                 % number of sats per plane
nplanes = sat_in.Nplanes;               % number of orbital planes
inc     = sat_in.Inclination.*dtr;      % Inclination in rad
h       = sat_in.Altitude;
angle_h = sat_in.FOVc/2;                % horizontal half angle for the optics
angle_v = sat_in.FOVv/2;                % vertical half angle for the optics
angle_a = sat_in.ULRXAntennaBeamwidth;  % cone angle for the S/C antenna
n_gs    = sat_in.NGroundStations;
lat_gs  = sat_in.LatGroundStations;     % ground station coordinates
lon_gs  = sat_in.LonGroundStations;
angle_gs = sat_in.AngleGroundStations;  % antenna angle for the ground stations


% Internal calculations
tStart  = 0;
tStop   = 86400.0;
tStep   = 60.0;
semimajorAxis = (Re + h)*1000;

% -------------------------------------------------------------------------
% Create constellation with nplanes separated Delta_RAAN = 180/nplanes deg  
% and nsats separated by Delta_Mean_Anom= 360/nsats deg
% -------------------------------------------------------------------------
raan = zeros(nsats*nplanes, 1);
MeanAnomaly = zeros(nsats*nplanes, 1);
z = 1;
for i=1:nplanes
    for j=1:nsats
        raan(z) = 180/nplanes.*(i-1);
        MeanAnomaly(z) = 360/nsats*(j-1);
        z = z + 1;
    end
end


% -------------------------------------------------------------------------
% Create a ground station, set locations, add a sensor to each
% -------------------------------------------------------------------------
for i = 1:n_gs
    facility_name = ['GS' num2str(i)];
    facility_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/'];
    
    % create a ground station
    stkNewObj(scenario_path, 'Facility', facility_name);
    
    % set location
    LLApos = [dtr*lat_gs(i); dtr*lon_gs(i)];
    stkSetFacPosLLA(facility_path, LLApos);

    % add a sensor to the ground station
    stkNewObj(facility_path, 'Sensor', 'Antenna');
    
    % set sensor properties
    fac_sensor_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/Sensor/Antenna'];
    stkSetSensor(conid, fac_sensor_path, 'SimpleCone', angle_gs);
    
end


% -------------------------------------------------------------------------
% Create a Coverage Grid
% -------------------------------------------------------------------------
coverage_name = 'Coverage1';
stkNewObj(scenario_path, 'CoverageDefinition', coverage_name);
coverage_path = ['/Scenario/' scenario_name '/' 'CoverageDefinition' '/' coverage_name '/'];
%Set coverage properties (latitude bounds) using stkSetCoverageBounds
lat_min = -70;
lat_max = +70;
stkSetCoverageBounds(conid,coverage_path, lat_min, lat_max);


% -------------------------------------------------------------------------
% Create Figure of Merit: Revisit Time
% -------------------------------------------------------------------------
FOM_name = 'Revisit_Time';
stkNewObj(coverage_path, 'FigureOfMerit', FOM_name);
FOM_path = [coverage_path 'FigureOfMerit/' FOM_name '/'];
stkSetCoverageFOM(conid, FOM_path, 'RevisitTime');


% -------------------------------------------------------------------------
% Create constellation of satellites
% -------------------------------------------------------------------------
for n=1:(nsats*nplanes)
    sat_name = ['Sat' num2str(n)];
  
    % Create one satellite
    stkNewObj(scenario_path, 'Satellite', sat_name);
    satellite_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/'];
    
    % Assign satellite orbit properties
    stkSetPropClassical(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], ...
        'J2Perturbation','J2000',tStart,tStop,tStep,0,semimajorAxis,0.0,inc,0.0,raan(n).*dtr,MeanAnomaly(n).*dtr);

    % Add a sensor (payload) to the satellite
    s = 1;
    sensor_name = ['Sensor' num2str(s)];
    stkNewObj(satellite_path, 'Sensor', sensor_name);
    sensor_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' sensor_name];

    % Set the satellite sensor using custom function (Rectangular)
    stkSetSensor(conid,sensor_path,'Rectangular',angle_h,angle_v);
    
    % Add a sensor (communnications) to the satellite
    antenna_name = ['Antenna' num2str(s)];
    stkNewObj(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], 'Sensor', antenna_name);
    antenna_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' antenna_name];
    
    % Set the communications sensor using custom function (Simple Cone)
    stkSetSensor(conid,antenna_path,'SimpleCone', angle_a);
    
    % Assign satellite as an asset to the coverage
    stkSetCoverageAsset(conid, coverage_path, sensor_path);

end


% -------------------------------------------------------------------------
% Compute metrics
% -------------------------------------------------------------------------

% Access calculation
stkComputeAccess(conid,coverage_path);

% Time to 100% coverage
[cov_data, cov_names] = stkReport(coverage_path, 'Percent Coverage');
time = stkFindData(cov_data{2}, 'Time');             % # of seconds past start time
cov  = stkFindData(cov_data{2}, '% Accum Coverage'); % accumlated coverage
coverage_time = NaN;
for i = 1:length(cov)
    if cov(i) >= 80
        coverage_time = time(i);
    break;
    end
end

% Percent coverage at the end of simulation period
final_cov = cov(end);

% Revisit time
[rt_data, rt_names] = stkReport(FOM_path, 'Value By Grid Point');
rt_value = stkFindData(rt_data{3}, 'FOM Value');    % revisit time by grid point
max_revisit_time = max(rt_value);
mean_revisit_time = mean(rt_value);


% -------------------------------------------------------------------------
% Assign outputs
% -------------------------------------------------------------------------
sat_out = sat_in;
sat_out.RevisitTimeMax  = max_revisit_time;
sat_out.RevisitTimeMean = mean_revisit_time;
sat_out.CoverageTime    = coverage_time;
sat_out.FinalCoverage   = final_cov;


% -------------------------------------------------------------------------
% Close all objects except the scenario
% -------------------------------------------------------------------------
objects = stkObjNames;
for i = length(objects):-1:2
    stkUnload(objects{i});
end


return;

% end sat_stk.m