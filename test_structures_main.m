function test_structures_main() % Include surfaceArea
% A function that tests the structures subsystem by generating components
% based on the payload that the user wants to generate. This function
% allows the user to skip the process of having to deal with extra time
% waiting for other subsystems to perform calculations

% These are the necessary folders to test the subsystem
addpath Structures
addpath LV
addpath Plotting
addpath Payload

% Select the payload the user wants to try out.
% payloadType = 1; % MicroMAS payload
% payloadType = 2; % Central Cylinder Commsat Payload payload
payloadType = 4; % Panel Mounted Comms Satellite payload

% Generate the components that work with that type of payload
satInfo = InitializingSubsystems(payloadType);

% Call the main structures function
[satInfo.structures] = structures_main(satInfo.components);

% Select the Launch Vehicle from the structures information
satInfo.LV = LV_selection(satInfo.payload,satInfo.structures);

% Plot all the information in the GUI
PlotSatInfo(satInfo.payload,satInfo.comms,satInfo.eps,satInfo.avionics,satInfo.thermal,satInfo.structures,satInfo.propulsion,satInfo.LV)



function satInfo = InitializingSubsystems(payloadType)

% Create the payload requested
payload = CreatePayload(payloadType);
if payloadType == 1
    % If it is the MicroMAS satellite

    components = CreateSampleComponents_Cubesat();
    
elseif payloadType == 2

    components = CreateSampleComponents_Cylinder();
    
    
elseif payloadType == 3

    components = CreateSampleComponents_PanelMounted();

elseif payloadType == 4
    components = CreateSampleComponents_Stacked();
    
end

components = [components, payload.comp];

% [components] = CreateSampleComponents_Stacked();



propulsion.mass = 30;
propulsion.power = 23;
propulsion.cost = 12;

comms.mass = 50;
comms.cost = 12;
comms.power = 120;
comms.Pt = 2;
comms.Dr = 4;
comms.EbN0 = 90;
comms.D = 23;
comms.Pt = 23;
comms.Gr = 23;
comms.EbN0min = 23;
comms.Gt = 23;
comms.Ls = 23;
comms.Tr = 23;
comms.Margin = 23;
comms.f = 23;
comms.Rb = 23;
comms.R = 23;
comms.modulation = 23;

thermal.mass = 34;
thermal.cost = 123;
thermal.power = 120;

eps.mass = 23;
eps.cost = 134;
eps.power = 120;
 
avionics.Mass = 54;
avionics.AvgPwr = 100;
avionics.Cost = 100;

satInfo.components = components;
satInfo.comms = comms;
satInfo.eps = eps;
satInfo.avionics = avionics;
satInfo.propulsion = propulsion;
satInfo.thermal = thermal;
satInfo.payload = payload;