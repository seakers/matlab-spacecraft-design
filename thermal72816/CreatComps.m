function [components] = CreatComps
% This is a generated for testing purpose on thermal subsystem. All the
% dimension data are made up. Will be replaced by real data entry when
% available

i = 1;
% Payload
components(i).Name = 'Payload';
components(i).Shape = 'Rectangle';
components(i).Mass = 1;
components(i).Dim = [0.1,0.1,0.1];
components(i).Thermal=[-10,50];
components(i).LocationReq = 'Inside';
components(i).Power=3;
components(i).CG_XYZ=[0,0,0.2191];

i=i+1;


%Filters
components(i).Name = 'Filters';
components(i).Shape = 'Rectangle';
components(i).Mass = 2;
components(i).Dim = [0.15,0.3,0.06];
components(i).CG_XYZ=[-0.1026,-0.1776,0.0360];
components(i).Thermal=[7,55];
components(i).LocationReq = 'Inside';
components(i).Power=0.01;

i = i+1;


%Electronics
components(i).Name = 'Electronics';
components(i).Shape = 'Rectangle';
components(i).Mass = .5;
components(i).Dim = [0.14,0.33,0.07];
components(i).CG_XYZ=[-0.0876,-0.0316,0.0410];
components(i).Thermal=[-10,55];
components(i).LocationReq = 'Inside';
components(i).Power=0.25;

i = i+1;

% Antenna
components(i).Name = 'Antenna';
components(i).Shape = 'Rectangle';
components(i).Mass = 0.0037;
components(i).Dim = [0.0249,0.033,0.0033];
components(i).Thermal=[-95,70];
components(i).LocationReq = 'Outside';
components(i).Power=0.3;
components(i).CG_XYZ=[-0.2563,0.1086,0.01242];

i = i + 1;

% OBC
components(i).Name = 'OBC';
components(i).Shape = 'Rectangle';
components(i).Mass = .3308;
components(i).Dim = [0.091,0.124,0.055];
components(i).Thermal=[-40,100];
components(i).LocationReq = 'Inside';
components(i).Power=0.77;
components(i).CG_XYZ=[-0.1906,0.0847,0.0335];

i = i + 1;

% Solar Panel
components(i).Name = 'Solar Panel';
components(i).Shape = 'Rectangle';
components(i).Mass = .9309;
components(i).Dim = [0.1681,0.5043,0.0084];
components(i).Thermal=[-105,110];
components(i).LocationReq = 'Outside';
components(i).Power=12;
components(i).CG_XYZ=[0.0025,0.258,0.084];

i=i+1;

% Solar Panel
components(i).Name = 'Solar Panel';
components(i).Shape = 'Rectangle';
components(i).Mass = .9309;
components(i).Dim = [0.1681,0.5043,0.0084];
components(i).Thermal=[-105,110];
components(i).LocationReq = 'Outside';
components(i).Power=12;
components(i).CG_XYZ=[-0.0025,-0.258,0.084];

i=i+1;

% Batteries
components(i).Name = 'Battery';
components(i).Shape = 'Rectangle';
components(i).Mass = .2;
components(i).Dim = [0.0353,0.0353,0.0353];
components(i).Thermal=[-5,20];
components(i).LocationReq = 'Inside';
components(i).Power=10;
components(i).CG_XYZ=[-0.0736,0.05702165,0.023];

i = i + 1;

% Wiring
components(i).Name = 'Wiring';
components(i).Shape = 'Rectangle';
components(i).Mass = .2345;
components(i).Dim = [0.0353,0.0353,0.0353];
components(i).Thermal=[-10,40];
components(i).LocationReq = 'Inside';
components(i).Power=0.03;
components(i).CG_XYZ=[-0.11,0.057,0.0236];

i = i + 1;

% Reaction Wheel 1
components(i).Name = 'Reaction Wheel 1';
components(i).Shape = 'Cylinder';
components(i).Mass = .052;
components(i).Dim = [0.06,0.045];
components(i).Thermal=[-5,45];
components(i).LocationReq = 'Inside';
components(i).Power=0.12;
components(i).CG_XYZ=[-0.01,0.0693,0.051];

i = i + 1;

% Reaction Wheel 2
components(i).Name = 'Reaction Wheel 2';
components(i).Shape = 'Cylinder';
components(i).Mass = .052;
components(i).Dim = [0.06,0.045];
components(i).Thermal=[-5,45];
components(i).LocationReq = 'Inside';
components(i).Power=0.12;
components(i).CG_XYZ=[0.0809,0.0692,0.051];

i = i + 1;

% Reaction Wheel 3
components(i).Name = 'Reaction Wheel 3';
components(i).Shape = 'Cylinder';
components(i).Mass = .052;
components(i).Dim = [0.06,0.045];
components(i).Thermal=[-5,45];
components(i).LocationReq = 'Inside';
components(i).Power=0.12;
components(i).CG_XYZ=[0.17,0.069,0.051];

i=i+1;

% Magnetic Torquer 1
components(i).Name = 'Magnetic Torquer 1';
components(i).Shape = 'Rectangle';
components(i).Mass = .0018;
components(i).Dim = [0.37,0.0189,.0183];
components(i).Thermal=[0,50];
components(i).LocationReq = 'Inside';
components(i).Power=0.5;
components(i).CG_XYZ=[0.0945,0.1188,0.0182];

i = i + 1;

% Magnetic Torquer 2
components(i).Name = 'Magnetic Torquer 2';
components(i).Shape = 'Rectangle';
components(i).Mass = .0018;
components(i).Dim = [0.37,0.0189,.0183];
components(i).Thermal=[0,50];
components(i).LocationReq = 'Inside';
components(i).Power=0.5;
components(i).CG_XYZ=[-0.1581,0.1497,0.01825];

i = i + 1;

% Magnetic Torquer 3
components(i).Name = 'Magnetic Torquer 3';
components(i).Shape = 'Rectangle';
components(i).Mass = .0018;
components(i).Dim = [0.37,0.0189,.0183];
components(i).Thermal=[0,50];
components(i).LocationReq = 'Inside';
components(i).Power=0.5;
components(i).CG_XYZ=[0.0945,0.1568,0.0182];

i = i + 1;

% Sensors 1
components(i).Name = 'Sensors 1';
components(i).Shape = 'Rectangle';
components(i).Mass = .004;
components(i).Dim = [0.014,0.0274,0.0059];
components(i).Thermal=[15,25];
components(i).LocationReq = 'Outside';
components(i).Power=0.65;
components(i).CG_XYZ=[-0.257,0.1966,0.007];

i = i + 1;

% Sensors 2
components(i).Name = 'Sensors 2';
components(i).Shape = 'Rectangle';
components(i).Mass = .004;
components(i).Dim = [0.014,0.0274,0.0059];
components(i).Thermal=[15,25];
components(i).LocationReq = 'Outside';
components(i).Power=0.65;
components(i).CG_XYZ=[-0.257,0.1682,0.007];

i = i + 1;

% Sensors 3
components(i).Name = 'Sensors 3';
components(i).Shape = 'Rectangle';
components(i).Mass = .004;
components(i).Dim = [0.014,0.0274,0.0059];
components(i).Thermal=[15,25];
components(i).LocationReq = 'Outside';
components(i).Power=0.65;
components(i).CG_XYZ=[-0.257,0.1398,0.007];

i = i + 1;

% Sensors 4
components(i).Name = 'Sensors 4';
components(i).Shape = 'Rectangle';
components(i).Mass = .033;
components(i).Dim = [0.0318,0.0433,0.0318];
components(i).Thermal=[15,25];
components(i).LocationReq = 'Outside';
components(i).Power=0.2;
components(i).CG_XYZ=[-0.2705,0.232,0.0159];

i = i + 1;


% Star Sensor
components(i).Name = 'Star Sensor';
components(i).Shape = 'Rectangle';
components(i).Mass = 1.2;
components(i).Dim = [0.155,0.21,0.056];
components(i).Thermal=[-50,70];
components(i).LocationReq = 'Outside';
components(i).Power=0.17;
components(i).CG_XYZ=[0.2826,-0.14964,0.0775];

i = i + 1;


% Star Sensor
components(i).Name = 'fake component';
components(i).Shape = 'Rectangle';
components(i).Mass = 1.2;
components(i).Dim = [0.155,0.21,0.056];
components(i).Thermal=[-700,-650];
components(i).LocationReq = 'Outside';
components(i).Power=500;
components(i).CG_XYZ=[0.2826,-0.14964,0.0775];




end