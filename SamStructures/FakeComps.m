function [fake_comp] = FakeComps()
% Generates fake comp struct to test with

payload.comp = struct('Name','Payload','Subsystem','Payload','Shape'...
    ,'Rectangle','Mass',1,'Dim',[.1,.1,.1],'CG_XYZ',[],'Vertices',[]...
    ,'LocationReq','Specific','RotateToSatBodyFrame',[1,0,0;0,1,0;0,0,0],'Thermal',[],'InertiaMatrix',[],'Volume',[],'HeatPower',3);

% payload.comp(2) = struct('Name','Payload','Subsystem','Payload','Shape',...
%     'Rectangle','Mass',1,'Dim',[.1,.1,.1],'CG_XYZ',[],'Vertices',[]...
%     ,'LocationReq','Specific','Orientation',[],'Thermal',[],'InertiaMatrix',[],'Volume',[],'HeatPower',3);

comms.comp(1) = struct('Name','Filters/Diplexers','Subsystem','Comms','Shape','Rectangle'...
    ,'Mass',1,'Dim',[.1,.1,.05],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside'...
    ,'RotateToSatBodyFrame',[1,0,0;0,1,0;0,0,0],'Thermal',[-40,100],'InertiaMatrix',[],'Volume',[],'HeatPower',0);

comms.comp(2) = struct('Name','Antenna','Subsystem','Comms','Shape','Rectangle'...
    ,'Mass',.0035,'Dim',[.025,.033,.0033],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside'...
    ,'RotateToSatBodyFrame',[1,0,0;0,1,0;0,0,0],'Thermal',[-40,100],'InertiaMatrix',[],'Volume',[],'HeatPower',.2);

eps.comp(1) = struct('Name','Solar Panel','Subsystem','EPS','Shape',...
    'Rectangle','Mass',1,'Dim',[.2,.2,.005],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside'...
    ,'RotateToSatBodyFrame',[1,0,0;0,1,0;0,0,0],'Thermal',[-40,100],'InertiaMatrix',[],'Volume',[],'HeatPower',0.1);

eps.comp(2) = struct('Name','Solar Panel','Subsystem','EPS','Shape','Rectangle'...
    ,'Mass',1,'Dim',[.2,.2,.005],'CG_XYZ',[],'Vertices',[],'LocationReq','Outside'...
    ,'RotateToSatBodyFrame',[1,0,0;0,1,0;0,0,0],'Thermal',[-40,100],'InertiaMatrix',[],'Volume',[],'HeatPower',.1);

eps.comp(3) = struct('Name','Battery','Subsystem','EPS','Shape','Rectangle','Mass',.03...
    ,'Dim',[.1,.12,.01],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside'...
    ,'RotateToSatBodyFrame',[1,0,0;0,1,0;0,0,0],'Thermal',[-40,100],'InertiaMatrix',[],'Volume',[],'HeatPower',.3);

adcs.comp = struct('Name','Reaction Wheel','Subsystem','ADCS','Shape','Cylinder',...
    'Mass',.3,'Dim',[.05,.1,0],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside'...
    ,'RotateToSatBodyFrame',[1,0,0;0,1,0;0,0,0],'Thermal',[-40,100],'InertiaMatrix',[],'Volume',[],'HeatPower',.5);

avionics.comp = struct('Name','OBC','Subsystem','Avionics','Shape','Rectangle','Mass',.2...
    ,'Dim',[.1,.1,.02],'CG_XYZ',[],'Vertices',[],'LocationReq','Inside'...
    ,'RotateToSatBodyFrame',[1,0,0;0,1,0;0,0,0],'Thermal',[-40,85],'InertiaMatrix',[],'Volume',[],'HeatPower',1);


fake_comp = [payload.comp comms.comp eps.comp adcs.comp avionics.comp];

end
