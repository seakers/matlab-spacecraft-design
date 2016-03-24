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

raan = [-45 -15 15 45];
nsat = 4;



% path to use
% (may have to change this)
%path = 'C:\Users\owner\Documents\MIT\16.851\STK';

% initialize the STK/MATLAB interface
agiInit;
stkInit;
remMachine = stkDefaultHost;
% open a socket to STK
conid = stkOpen(remMachine);

% create a scenario
scenario_name = 'stk_example';
stkNewObj('/','Scenario','stk_example');

% % open existing scenario ?
% stkExec(conid, 'Open / Scenario Scenario1');

% create satellites
for n=1:nsat
    sat_name = ['Sat' num2str(n)];
    
   
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
    %raan    = -45*dtr;

    stkSetPropClassical(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], ...
        'J2Perturbation','J2000',tStart,tStop,tStep,0,semimajorAxis,0.0,inc,0.0,raan(n).*dtr,0.0);

    % add a sensor to the satellite
    s = 1;
    sensor_name = ['Sensor' num2str(s)];
    stkNewObj(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], 'Sensor', sensor_name);

    % set the satellite sensor using custom function
    stkSetSensor(conid, ...
                 ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' sensor_name], ...
                 'Rectangular', ...
                 47, 23);                   % regtangular cone syntax
end
% create a ground station
facility_name = ['GS' num2str(n)];
stkNewObj(['/Scenario/' scenario_name '/'], 'Facility', facility_name);

% add a sensor to the ground station
stkNewObj(['/Scenario/' scenario_name '/Facility/' facility_name '/'], 'Sensor', 'Antenna');

% print object names and paths
stkObjNames;

% close out the stk connection
stkClose(conid);

% close any default connection
stkClose;

% end stk_example.m