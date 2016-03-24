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

nsats   = sat_in.Nsats;                 % number of sats per plane
nplanes = sat_in.Nplanes;               % number of orbital planes
inc     = sat_in.Inclination.*dtr;      % Inclination in rad
h       = sat_in.Altitude;
angle_h = sat_in.AngleHorizSTK;         % horizontal half angle for the sensor
angle_v = sat_in.AngleVertSTK;          % vertical half angle for the sensor
D_SAT   = sat_in.ULRXAntennaDiameter;
n_gs    = sat_in.NGroundStations;
lat_gs  = sat_in.LatGroundStations;     % ground station coordinates
lon_gs  = sat_in.LonGroundStations;
f_GHz   = sat_in.DLFrequency/1E9;
D_GS    = sat_in.ULTXAntennaDiameter; % Diameter of the ground station antenna


% Internal calculations



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
    stkSetSensor(conid, fac_sensor_path, 'HalfPower', f_GHz, D_GS);
    
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
FOM_name1 = 'Revisit_Time';
stkNewObj(coverage_path, 'FigureOfMerit', FOM_name1);
FOM_path1 = [coverage_path 'FigureOfMerit/' FOM_name1 '/'];
stkSetCoverageFOM(conid, FOM_path1, 'RevisitTime');

% -------------------------------------------------------------------------
% Create Figure of Merit: Response Time
% -------------------------------------------------------------------------
FOM_name2 = 'Response_Time';
stkNewObj(coverage_path, 'FigureOfMerit', FOM_name2);
FOM_path2 = [coverage_path 'FigureOfMerit/' FOM_name2 '/'];
stkSetCoverageFOM(conid, FOM_path2, 'ResponseTime');


% -------------------------------------------------------------------------
% Create constellation with nplanes separated Delta_RAAN = 180/nplanes deg  
% and nsats separated by Delta_Mean_Anom= 360/nsats deg
% -------------------------------------------------------------------------
tStart  = 0;
tStop   = 86400.0;
tStep   = 3.0;
semimajorAxis = (Re + h)*1000;

% Calculate the RAAN and mean anomaly of each satellite
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


for n=1:(nsats*nplanes)
    sat_name = ['Sat' num2str(n)];
  
    % Create one satellite
    stkNewObj(scenario_path, 'Satellite', sat_name);
    satellite_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/'];
    
    % Assign orbit properties to the satellite
    stkSetPropClassical(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], ...
        'J2Perturbation','J2000',tStart,tStop,tStep,0,semimajorAxis,0.0,inc,0.0,raan(n).*dtr,MeanAnomaly(n).*dtr);

    % Add a sensor (payload) to the satellite
    s = 1;
    sensor_name = ['Sensor' num2str(s)];
    stkNewObj(satellite_path, 'Sensor', sensor_name);
    sensor_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' sensor_name];

    % Set the satellite sensor using custom function (Rectangular)
    stkSetSensor(conid,sensor_path,'Rectangular',angle_v,angle_h);
    
    % Add a sensor (communnications) to the satellite
    antenna_name = ['Antenna' num2str(s)];
    stkNewObj(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], 'Sensor', antenna_name);
    antenna_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' antenna_name];
    
    % Set the communications sensor using custom function (Simple Cone)
    stkSetSensor(conid,antenna_path,'HalfPower', f_GHz, D_SAT);
    
    % Assign satellite's sensor as an asset to the coverage
    stkSetCoverageAsset(conid, coverage_path, sensor_path);
    
    % Assign both ground stations as assets for each satellite's antenna
    for m = 1:n_gs
        facility_name = ['GS' num2str(m)];
        fac_sensor_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/Sensor/Antenna'];
        stkSetCoverageAsset(conid, antenna_path, fac_sensor_path);
    end


end

% -------------------------------------------------------------------------
% Compute communications metrics
% -------------------------------------------------------------------------

% COMPUTE COMMUNICATION LINK DURATION (MAX, MEAN, MIN, TOTAL)

% Create a file containing the paths of the antennas
targetsfile = 'C:\Users\Dani\Documents\PhD\coursework\16.851 Satellite engineering\project\models\matlab\targets.txt';
fid = fopen(targetsfile,'w');

for n=1:(nsats*nplanes)
    sat_name = ['Sat' num2str(n)];
    target_path = ['Satellite/' sat_name '/Sensor/Antenna1/'];
    fprintf(fid,'%s\n',target_path);

end

fclose(fid);

targetsfile = ['"' targetsfile '"'];
% Assign targets to ground station antennas using the file
for i = 1:n_gs
    facility_name = ['GS' num2str(i)];
    fac_sensor_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/Sensor/Antenna'];

    % Assign the targets in the file to the ground station
    AssignTargetToSensor(conid, fac_sensor_path, targetsfile);
end


% Initializations for computing performance
mean_comm_time = zeros(nsats*nplanes,1);
max_comm_time = zeros(nsats*nplanes,1);
min_comm_time = zeros(nsats*nplanes,1);
total_comm_time = zeros(nsats*nplanes,1);

min_resp_time = zeros(nsats*nplanes,1);
max_resp_time = zeros(nsats*nplanes,1);
mean_resp_time = zeros(nsats*nplanes,1);

for i = 1:(nsats*nplanes)
    sat_name = ['Sat' num2str(i)];
    sat_antenna_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/Antenna1/'];
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ACCESS DURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Compute Access of each sat to both GS
    call = ['Cov_RM ' sat_antenna_path ' Access Compute "Coverage"'];
    results = stkExec(conid,call);
    Naccesses = size(results,1)-2;
    dur_access = zeros(Naccesses,1);
    for k = 1:Naccesses
        dur_access(k) = sscanf(results(k+1,:),'%*d,%*[^,],%*[^,],%f');
    end

    % Compute max, mean, min and total access duration for each satellite 
    mean_comm_time(i)     = mean(dur_access);
    max_comm_time(i)      = max(dur_access);
    min_comm_time(i)      = min(dur_access);
    total_comm_time(i)    = sum(dur_access);

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % RESPONSE TIME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define FOM Response Time for each satellite
    call = ['Cov ' sat_antenna_path ' FOMDefine Definition ResponseTime Compute Average'];
    stkExec(conid,call);
    
    % Compute RT
    call = ['Cov ' sat_antenna_path ' Access Compute Export "FOM Value" "C:\Users\Dani\Documents\PhD\coursework\16.851 Satellite engineering\project\models\matlab\results.csv"'];
    stkExec(conid,call);
    
    % Read the file
    fid = fopen('C:\Users\Dani\Documents\PhD\coursework\16.851 Satellite engineering\project\models\matlab\results.csv','r');
    C = textscan(fid,'%*[^,],%f\n','Headerlines',7,'BufSize',25000);
    resp_time = C{1};
    fclose(fid);
    
    % Suppress the 1e6 from the results (points after the last access are
    % fixed to 1e6 response time by STK)
    l = 1;
    for k = 1:length(resp_time)
        if resp_time(k) ~= 1000000
            resp_time2(l,1) = resp_time(k);
            l = l+1;
        else
            break;
        end
    end

    % Compute min, mean, max response time
    min_resp_time(i) = min(resp_time2);
    max_resp_time(i) = max(resp_time2);
    mean_resp_time(i) = mean(resp_time2);

    
end
% -------------------------------------------------------------------------
% Compute Optics metrics
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

% Revisit time for targets
[rt_data, rt_names] = stkReport(FOM_path1, 'Value By Grid Point');
rt_value = stkFindData(rt_data{3}, 'FOM Value');    % revisit time by grid point
max_revisit_time = max(rt_value);
mean_revisit_time = mean(rt_value);

% Response time for targets
[rt_data, rt_names] = stkReport(FOM_path2, 'Value By Grid Point');
rt_value = stkFindData(rt_data{3}, 'FOM Value');    % revisit time by grid point
max_response_time = max(rt_value);
mean_response_time = mean(rt_value);

% Calculate number of images per day
NImagesPerDay = 86400/mean_revisit_time;


% -------------------------------------------------------------------------
% Assign outputs
% -------------------------------------------------------------------------
sat_out = sat_in;
sat_out.RevisitTimeMax  = max_revisit_time;
sat_out.RevisitTimeMean = mean_revisit_time;
sat_out.ResponseTimeMax  = max_response_time;
sat_out.ResponseTimeMean = mean_response_time;
sat_out.CoverageTime    = coverage_time;
sat_out.FinalCoverage   = final_cov;

sat_out.CommDurationMax = max(max_comm_time);
sat_out.CommDurationMean = mean(mean_comm_time);
sat_out.CommDurationMin = min(min_comm_time);
sat_out.CommDurationTotal = sum(total_comm_time);

sat_out.CommRespTimeMax  = max(max_resp_time);
sat_out.CommRespTimeMean = mean(mean_resp_time);

sat_out.NImagesPerDay = NImagesPerDay;

% -------------------------------------------------------------------------
% Close all objects except the scenario
% -------------------------------------------------------------------------
objects = stkObjNames;
for i = length(objects):-1:2
    stkUnload(objects{i});
end


return;

% end sat_stk.m