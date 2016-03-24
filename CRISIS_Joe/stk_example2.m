% stk_example.m -- example script for interfacing with STK
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


remMachine = stkDefaultHost;

% path to use
% (may have to change this)
path = 'C:\Users\owner\Documents\MIT\16.851\STK';

% initialize the STK/MATLAB interface
% agiInit;
% stkInit;

% open a socket to STK
conid = stkOpen(remMachine);

% create a scenario
scenario_name = 'stk_example';
stkNewObj('/','Scenario','stk_example');

% % open existing scenario ?
% stkExec(conid, 'Open / Scenario Scenario1');

% create satellites
n = 1;
sat_name = ['Sat' num2str(n)];
sensor_name = ['Sensor' num2str(n)];
        
% creates one satellite
stkNewObj(['/Scenario/' scenario_name '/'], 'Satellite', sat_name);

% assign satellite orbit properties
dtr     = pi/180;
tStart  = 0;
tStop   = 86400.0;
tStep   = 60.0;
Re      = 6378;
h       = 567;
semimajorAxis = (Re + h)*1000;
inc     = 97.67*dtr;
raan    = -45*dtr;

stkSetPropClassical(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], ...
    'J2Perturbation','J2000',tStart,tStop,tStep,0,semimajorAxis,0.0,inc,0.0,raan,0.0);

% add a sensor to the satellite
stkNewObj(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], 'Sensor', sensor_name);

% set the satellite sensor
stkSetSensor(conid, ...
             ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' sensor_name], ...
             'Rectangular', ...
             47, 23);                   % regtangular cone syntax

% create a ground station
facility_name = ['GS' num2str(n)];
stkNewObj(['/Scenario/' scenario_name '/'], 'Facility', facility_name);

% add a sensor to the ground station
stkNewObj(['/Scenario/' scenario_name '/Facility/' facility_name '/'], 'Sensor', 'Antenna');

% add a coverage definition
stkNewObj(['/Scenario/' scenario_name '/'], 'CoverageDefinition', 'Coverage1');

% set latitude bounds on coverage definition
stkSetCoverageBounds(conid, '/Scenario/stk_example/CoverageDefinition/Coverage1', -70, 70);

% assign sensor as an asset of the coverage definition
stkSetCoverageAsset(conid, '/Scenario/stk_example/CoverageDefinition/Coverage1', ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' sensor_name]);

% compute accesses for the coverage definition
stkComputeAccess(conid, '/Scenario/stk_example/CoverageDefinition/Coverage1');

% generate a coverage definition report



% print object names and paths
stkObjNames;

% close out the stk connection
stkClose(conid);

% close any default connection
stkClose;

% end stk_example.m