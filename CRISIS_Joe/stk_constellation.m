function [] = stk_constellation(sat_in)
% stk_constellation.m -- 
%
% 
% STK demos
%   (all in C:\Program Files\AGI\STK 8\Matlab\Examples\)
%   basicSTK.m
%   aimx
%   gpsDemo
%   missileDefenseRadar
%   gpsInterferenceTool
%   ballisticInterceptDemo
%   rcsModel
%
% Other places to look...
%   help stk
%   help mexConnect
%   help aeroToolbox


%nsat    = 4;
dtr     = pi/180;
nsat    = sat_in.Nsats;
nplanes = sat_in.Nplanes;
inc = sat_in.Inclination.*dtr;
if mod(nsat,nplanes) == 0
    nsats_per_plane = nsat/nplanes;
else
    %error
    disp('error');
    return
end

h       = sat_in.Altitude;

tStart  = 0;
tStop   = 86400.0;
tStep   = 60.0;
Re      = 6378;
%h       = 567;
semimajorAxis = (Re + h)*1000;
%inc     = 97.67*dtr;
raan = zeros(nsat);
MeanAnomaly = zeros(nsat);
for i=1:nplanes
    for j=1:nsats_per_plane
        raan((i-1)*nplanes+j) = 180/nplanes.*(i-1);
        MeanAnomaly((i-1)*nplanes+j) = 360/nsats_per_plane*(j-1);
    end
end

% initialize the STK/MATLAB interface

agiInit;
stkInit;
remMachine = stkDefaultHost;
% open a socket to STK
conid = stkOpen(remMachine);

% create a scenario
scenario_name = 'CRISIS';
stkNewObj('/','Scenario',scenario_name);
scenario_path = ['/Scenario/' scenario_name '/'];

% create a ground station
n=1;
facility_name = ['GS' num2str(n)];
%stkNewObj(['/Scenario/' scenario_name '/'], 'Facility', facility_name);
stkNewObj(scenario_path, 'Facility', facility_name);
facility_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/'];
% add a sensor to the ground station
stkNewObj(facility_path, 'Sensor', 'Antenna');

% Creates a coverage grid
coverage_name = 'Coverage1';
stkNewObj(scenario_path, 'CoverageDefinition', coverage_name);
coverage_path = ['/Scenario/' scenario_name '/' 'CoverageDefinition' '/' coverage_name '/'];
%Set coverage properties stkSetCoverageBounds
lat_min = -70;
lat_max = +70;
stkSetCoverageBounds(conid,coverage_path, lat_min, lat_max)

%Create Figure of Merit: Revisit Time
FOM_name = 'Revisit_Time';
stkNewObj(coverage_path, 'FigureOfMerit', FOM_name);
FOM_path = [coverage_path 'FigureOfMerit/' FOM_name '/'];
stkSetCoverageFOM(conid, FOM_path, 'RevisitTime');


% create satellites
for n=1:nsat
    sat_name = ['Sat' num2str(n)];
  
    % creates one satellite
    stkNewObj(scenario_path, 'Satellite', sat_name);
    satellite_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/'];
    % assign satellite orbit properties

    %raan    = -45*dtr;

    stkSetPropClassical(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], ...
        'J2Perturbation','J2000',tStart,tStop,tStep,0,semimajorAxis,0.0,inc,0.0,raan(n).*dtr,MeanAnomaly(n).*dtr);

    % add a sensor to the satellite
    s = 1;
    sensor_name = ['Sensor' num2str(s)];
    stkNewObj(satellite_path, 'Sensor', sensor_name);
    sensor_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' sensor_name];

    % set the satellite sensor using custom function
    stkSetSensor(conid,sensor_path,'Rectangular',47,23);% regtangular cone syntax
             
    antenna_name = ['Antenna' num2str(s)];
    stkNewObj(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], 'Sensor', antenna_name);
    antenna_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' antenna_name];
    
    % set the satellite sensor using custom function
    stkSetSensor(conid,antenna_path,'SimpleCone',45);% regtangular cone syntax
    % Assign satellite as an asset to the coverage
    stkSetCoverageAsset(conid, coverage_path,sensor_path);
    
   
    

end
stkComputeAccess(conid,coverage_path);
stkGetReport(conid,FOM_path,'Value By Grid Point','Save','C:\Users\Dani\Documents\PhD\coursework\16.851 Satellite engineering\project\models\matlab\test.txt');


% print object names and paths
stkObjNames;

% close out the stk connection
stkClose(conid);

% close any default connection
stkClose;

% end stk_example.m