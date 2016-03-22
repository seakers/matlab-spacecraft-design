function [components] = CreateSampleComponents_Cylinder()
% Create sample components to be used by the code. They have arbitrary
% sizes and masses, not at all based on accurate calculations.

i = 1;
% Fuel Tank
components(i).Name = 'Fuel Tank';
components(i).Subsystem = 'Propulsion';
components(i).Shape = 'Sphere';
components(i).Mass = 150;
components(i).Dim = 0.4;
% components(1).isFit = 0;
components(i).CG_XYZ = [];
components(i).Vertices = [];
components(i).LocationReq = 'Specific';
components(i).Orientation = [];
components(i).Thermal = [];
components(i).InertiaMatrix = [];
components(i).RotateToSatBodyFrame = [];
i = i+1;

% Fuel Tank
components(i).Name = 'Fuel Tank 2';
components(i).Subsystem = 'Propulsion';
components(i).Shape = 'Sphere';
components(i).Mass = 150;
components(i).Dim = 0.3;
components(i).isFit = 0;
components(i).LocationReq = 'Specific';
i = i+1; 
% 
% % ADCS Computer
% components(2).Name = 'Computer';
% components(2).Subsystem = 'ADCS';
% components(2).Shape = 'Rectangle';
% components(2).Mass = 20;
% components(2).isFit = 0;
% components(2).Dim = [0.2,0.2,0.01];
% components(2).LocationReq = 'Inside';

% % Comms Electronics
% components(1).Name = 'Electronics';
% components(1).Subsystem = 'Comms';
% components(1).Shape = 'Rectangle';
% components(1).Mass = 10;
% components(1).isFit = 0;
% components(1).Dim = [0.2,0.1,0.1];
% components(1).LocationReq = 'Inside';

% Comms Electronics
components(i).Name = 'Electronics';
components(i).Subsystem = 'Comms';
components(i).Shape = 'Rectangle';
components(i).Mass = 10;
components(i).isFit = 0;
components(i).Dim = [0.2,0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;
%

% Payload
components(i).Name = 'Payload';
components(i).Subsystem = 'Payload';
components(i).Shape = 'Rectangle';
components(i).Mass = 10;
components(i).isFit = 0;
components(i).Dim = [.5,0.5,0.3];
components(i).LocationReq = 'Specific';
i = i + 1;

% Antenna
components(i).Name = 'Antenna';
components(i).Subsystem = 'Comms';
components(i).Shape = 'Rectangle';
components(i).Mass = 60;
components(i).isFit = 0;
components(i).Dim = [0.6,0.5,0.1];
components(i).LocationReq = 'Outside';
i = i + 1;
% components(4).LocationReq = 'Inside';

% Solar Panels

components(i).Name = 'Solar Panels';
components(i).Subsystem = 'EPS';
components(i).Shape = 'Rectangle';
components(i).Mass = 70;
components(i).isFit = 0;
components(i).Dim = [0.6,0.6,0.2];
components(i).LocationReq = 'Outside';
i = i + 1;
% components(5).LocationReq = 'Inside';
% 
% % Batteries
% components(i).Name = 'Battery';
% components(i).Subsystem = 'EPS';
% components(i).Shape = 'Rectangle';
% components(i).Mass = 90;
% components(i).isFit = 0;
% components(i).Dim = [0.5,0.3,0.2];
% components(i).LocationReq = 'Inside';
% i = i + 1;

% Power Electronics
components(i).Name = 'Electronics';
components(i).Subsystem = 'EPS';
components(i).Shape = 'Rectangle';
components(i).Mass = 10;
components(i).isFit = 0;
components(i).Dim = [0.2,0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;

% Reaction Wheel 1
components(i).Name = 'Reaction Wheel 1';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = 30;
components(i).isFit = 0;
components(i).Dim = [0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;

% Reaction Wheel 2
components(i).Name = 'Reaction Wheel 2';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = 30;
components(i).isFit = 0;
components(i).Dim = [0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;

% Reaction Wheel 3 
components(i).Name = 'Reaction Wheel 3';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = 30;
components(i).isFit = 0;
components(i).Dim = [0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;

% Reaction Wheel 4
components(i).Name = 'Reaction Wheel 4';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = 30;
components(i).isFit = 0;
components(i).Dim = [0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;

% Magnetometer
components(i).Name = 'Magnetometer';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Rectangle';
components(i).Mass = 10;
components(i).isFit = 0;
components(i).Dim = [0.1,0.1,.1];
components(i).LocationReq = 'Inside';

% Reaction Wheel 4
components(i).Name = 'Sensors';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Rectangle';
components(i).Mass = 10;
components(i).isFit = 0;
components(i).Dim = [0.1,0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;

% Thruster
components(i).Name = 'Thruster';
components(i).Subsystem = 'Propulsion';
components(i).Shape = 'Cylinder';
components(i).Mass = 30;
components(i).isFit = 0;
components(i).Dim = [0.2,0.1,0.3];
components(i).LocationReq = 'Specific';
i = i + 1;

% Magnetic Torquer
components(i).Name = 'Magnetic Torquer';
components(i).Subsystem = 'ADCS';
components(i).Shape = 'Cylinder';
components(i).Mass = 10;
components(i).isFit = 0;
components(i).Dim = [0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;

% Power Electronics
components(i).Name = 'Electronics 2';
components(i).Subsystem = 'EPS';
components(i).Shape = 'Rectangle';
components(i).Mass = 10;
components(i).isFit = 0;
components(i).Dim = [0.2,0.1,0.1];
components(i).LocationReq = 'Inside';
i = i + 1;
% 
