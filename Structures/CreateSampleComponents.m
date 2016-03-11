function [components] = CreateSampleComponents()
% Create sample components to be used by the code. They have arbitrary
% sizes and masses, not at all based on accurate calculations.

% Fuel Tank
components(1).Name = 'Fuel Tank';
components(1).Subsystem = 'Propulsion';
components(1).Shape = 'Sphere';
components(1).Mass = 150;
components(1).Dim = 0.4;
% components(1).isFit = 0;
components(1).CG_XYZ = [];
components(1).Vertices = [];
components(1).LocationReq = 'Specific';
components(1).Orientation = [];
components(1).Thermal = [];
components(1).InertiaMatrix = [];
components(1).RotateToSatBodyFrame = [];

% Fuel Tank
components(2).Name = 'Fuel Tank 2';
components(2).Subsystem = 'Propulsion';
components(2).Shape = 'Sphere';
components(2).Mass = 150;
components(2).Dim = 0.3;
components(2).isFit = 0;
components(2).LocationReq = 'Specific';

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
components(3).Name = 'Electronics';
components(3).Subsystem = 'Comms';
components(3).Shape = 'Rectangle';
components(3).Mass = 10;
components(3).isFit = 0;
components(3).Dim = [0.2,0.1,0.1];
components(3).LocationReq = 'Inside';
% 
% Antenna
components(4).Name = 'Antenna';
components(4).Subsystem = 'Comms';
components(4).Shape = 'Rectangle';
components(4).Mass = 60;
components(4).isFit = 0;
components(4).Dim = [0.6,0.5,0.1];
components(4).LocationReq = 'Outside';
% components(4).LocationReq = 'Inside';

% Solar Panels
components(5).Name = 'Solar Panels';
components(5).Subsystem = 'EPS';
components(5).Shape = 'Rectangle';
components(5).Mass = 70;
components(5).isFit = 0;
components(5).Dim = [0.6,0.6,0.2];
components(5).LocationReq = 'Outside';
% components(5).LocationReq = 'Inside';
% 
% Batteries
components(6).Name = 'Battery';
components(6).Subsystem = 'EPS';
components(6).Shape = 'Rectangle';
components(6).Mass = 90;
components(6).isFit = 0;
components(6).Dim = [0.5,0.3,0.2];
components(6).LocationReq = 'Inside';

% Power Electronics
components(7).Name = 'Electronics';
components(7).Subsystem = 'EPS';
components(7).Shape = 'Rectangle';
components(7).Mass = 10;
components(7).isFit = 0;
components(7).Dim = [0.2,0.1,0.1];
components(7).LocationReq = 'Inside';

% Reaction Wheel 1
components(8).Name = 'Reaction Wheel 1';
components(8).Subsystem = 'ADCS';
components(8).Shape = 'Cylinder';
components(8).Mass = 30;
components(8).isFit = 0;
components(8).Dim = [0.1,0.1];
components(8).LocationReq = 'Inside';

% Reaction Wheel 2
components(9).Name = 'Reaction Wheel 2';
components(9).Subsystem = 'ADCS';
components(9).Shape = 'Cylinder';
components(9).Mass = 30;
components(9).isFit = 0;
components(9).Dim = [0.1,0.1];
components(9).LocationReq = 'Inside';


% Reaction Wheel 3 
components(10).Name = 'Reaction Wheel 3';
components(10).Subsystem = 'ADCS';
components(10).Shape = 'Cylinder';
components(10).Mass = 30;
components(10).isFit = 0;
components(10).Dim = [0.1,0.1];
components(10).LocationReq = 'Inside';

% Reaction Wheel 4
components(11).Name = 'Reaction Wheel 4';
components(11).Subsystem = 'ADCS';
components(11).Shape = 'Cylinder';
components(11).Mass = 30;
components(11).isFit = 0;
components(11).Dim = [0.1,0.1];
components(11).LocationReq = 'Inside';

% Magnetometer
components(12).Name = 'Magnetometer';
components(12).Subsystem = 'ADCS';
components(12).Shape = 'Rectangle';
components(12).Mass = 10;
components(12).isFit = 0;
components(12).Dim = [0.1,0.1,.1];
components(12).LocationReq = 'Inside';

% Reaction Wheel 4
components(13).Name = 'Sensors';
components(13).Subsystem = 'ADCS';
components(13).Shape = 'Rectangle';
components(13).Mass = 10;
components(13).isFit = 0;
components(13).Dim = [0.1,0.1,0.1];
components(13).LocationReq = 'Inside';

% Thruster
components(14).Name = 'Thruster';
components(14).Subsystem = 'Propulsion';
components(14).Shape = 'Cylinder';
components(14).Mass = 30;
components(14).isFit = 0;
components(14).Dim = [0.2,0.1,0.3];
components(14).LocationReq = 'Specific';

% Magnetic Torquer
components(15).Name = 'Magnetic Torquer';
components(15).Subsystem = 'ADCS';
components(15).Shape = 'Cylinder';
components(15).Mass = 10;
components(15).isFit = 0;
components( 15).Dim = [0.1,0.1];
components(15).LocationReq = 'Inside';

% Power Electronics
components(16).Name = 'Electronics 2';
components(16).Subsystem = 'EPS';
components(16).Shape = 'Rectangle';
components(16).Mass = 10;
components(16).isFit = 0;
components(16).Dim = [0.2,0.1,0.1];
components(16).LocationReq = 'Inside';
% 

