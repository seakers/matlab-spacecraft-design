function [components] = CreateSampleComponents_Cubesat()
% Create sample components to be used by the code. They have arbitrary
% sizes and masses, not at all based on accurate calculations.

i = 1;
% % Fuel Tank
% components(1).Name = 'Fuel Tank';
% components(1).Subsystem = 'Propulsion';
% components(1).Shape = 'Sphere';
% components(1).Mass = 150;
% components(1).Dim = 0.4;
% % components(1).isFit = 0;
% components(1).CG_XYZ = [];
% % components(1).Vertices = [];
% % components(1).LocationReq = 'Specific';
% % components(1).Orientation = [];
% % components(1).Thermal = [];
% % components(1).InertiaMatrix = [];
% % components(1).RotateToSatBodyFrame = [];
% % 
% % % Fuel Tank
% % components(2).Name = 'Fuel Tank 2';
% % components(2).Subsystem = 'Propulsion';
% % components(2).Shape = 'Sphere';
% % components(2).Mass = 150;
% % components(2).Dim = 0.3;
% % components(2).isFit = 0;
% % components(2).LocationReq = 'Specific';
% 
% % 
% 
% % ADCS Computer
components(i).Name = 'Computer';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Rectangle';
components(i).Mass = .01;
components(i).isFit = 0;
components(i).CG_XYZ = [];
components(i).Vertices = [];
components(i).Dim = [0.005,0.005,0.001];
components(i).LocationReq = 'Inside';
components(i).Orientation = [];
components(i).Thermal = [];
components(i).InertiaMatrix = [];
components(i).RotateToSatBodyFrame = [];
i = i+1; 

% Comms Electronics
components(i).Name = 'Electronics';
components(i).Subsystem = 'Comms';
components(i).Shape = 'Rectangle';
components(i).Mass = .02;
components(i).isFit = 0;
components(i).Dim = [0.02,0.005,0.001];
components(i).LocationReq = 'Inside';
i = i+1;

% Comms Electronics
components(i).Name = 'Electronics';
components(i).Subsystem = 'Comms';
components(i).Shape = 'Rectangle';
components(i).Mass = 0.01;
components(i).isFit = 0;
components(i).Dim = [0.02,0.01,0.001];
components(i).LocationReq = 'Inside';
i = i + 1;
%

% Antenna
components(i).Name = 'Antenna';
components(i).Subsystem = 'Comms';
components(i).Shape = 'Rectangle';
components(i).Mass = .005;
components(i).isFit = 0;
components(i).Dim = [0.06,0.05,0.01];
components(i).LocationReq = 'Outside';
i = i + 1;

% Solar Panels
nPanels = 1;
for j = i:i+nPanels
components(j).Name = 'Solar Panels';
components(j).Subsystem = 'EPS';
components(j).Shape = 'Rectangle';
components(j).Mass = .007;
components(j).isFit = 0;
components(j).Dim = [0.2,0.1,0.0002];
components(j).LocationReq = 'Outside';
end
i = i + nPanels+1;

% components(5).LocationReq = 'Inside';
% 
% Batteries
components(i).Name = 'Battery';
components(i).Subsystem = 'EPS';
components(i).Shape = 'Rectangle';
components(i).Mass = .2;
components(i).isFit = 0;
components(i).Dim = [0.05,0.003,0.0001];
components(i).LocationReq = 'Inside';
i = i + 1;

% Power Electronics
components(i).Name = 'Electronics';
components(i).Subsystem = 'EPS';
components(i).Shape = 'Rectangle';
components(i).Mass = .004;
components(i).isFit = 0;
components(i).Dim = [0.02,0.01,0.001];
components(i).LocationReq = 'Inside';
i = i + 1;

% Reaction Wheel 1
components(i).Name = 'Reaction Wheel 1';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = .01;
components(i).isFit = 0;
components(i).Dim = [0.008,0.005];
components(i).LocationReq = 'Inside';
i = i + 1;

% Reaction Wheel 2
components(i).Name = 'Reaction Wheel 2';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = .01;
components(i).isFit = 0;
components(i).Dim = [0.008,0.005];
components(i).LocationReq = 'Inside';
i = i + 1;

% Reaction Wheel 3 
components(i).Name = 'Reaction Wheel 3';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = .01;
components(i).isFit = 0;
components(i).Dim = [0.008,0.005];
components(i).LocationReq = 'Inside';
i = i + 1;

% Reaction Wheel 4
components(i).Name = 'Reaction Wheel 4';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = 0.01;
components(i).isFit = 0;
components(i).Dim = [0.008,0.005];
components(i).LocationReq = 'Inside';
i = i + 1;

% Magnetometer
components(i).Name = 'Magnetometer';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Rectangle';
components(i).Mass = .0001;
components(i).isFit = 0;
components(i).Dim = [0.1,0.1,.1];
components(i).LocationReq = 'Inside';

% Sensors
components(i).Name = 'Sensors';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Rectangle';
components(i).Mass = .02;
components(i).isFit = 0;
components(i).Dim = [0.01,0.01,0.001];
components(i).LocationReq = 'Inside';
i = i + 1;
% 
% % Thruster
% components(i).Name = 'Thruster';
% components(i).Subsystem = 'Propulsion';
% components(i).Shape = 'Cylinder';
% components(i).Mass = 30;
% components(i).isFit = 0;
% components(i).Dim = [0.2,0.1,0.3];
% components(i).LocationReq = 'Specific';
% i = i + 1;

% Magnetic Torquer
components(i).Name = 'Magnetic Torquer';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = 10;
components(i).isFit = 0;
components(i).Dim = [0.01,0.01];
components(i).LocationReq = 'Inside';
i = i + 1;

% Power Electronics
components(i).Name = 'Electronics 2';
components(i).Subsystem = 'EPS';
components(i).Shape = 'Rectangle';
components(i).Mass = .01;
components(i).isFit = 0;
components(i).Dim = [0.02,0.01,0.001];
components(i).LocationReq = 'Inside';
i = i + 1;

nElectronics = 50;
for j = i:i+nElectronics
    components(j).Name = 'Electronics 2';
    components(j).Subsystem = 'EPS';
    components(j).Shape = 'Rectangle';
    components(j).Mass = .01;
    components(j).isFit = 0;
    components(j).Dim = [0.02,0.01,0.001];
    components(j).LocationReq = 'Inside';
end
i = i + nElectronics+1;

% % Comms Electronics
% components(i).Name = 'Payload';
% components(i).Subsystem = 'Payload';
% components(i).Shape = 'Rectangle';
% components(i).Mass = 1;
% components(i).isFit = 0;
% components(i).Dim = [0.1,0.1,0.1];
% components(i).LocationReq = 'Specific';
% i = i + 1;
%
