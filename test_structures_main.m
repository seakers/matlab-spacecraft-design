function test_structures_main() % Include surfaceArea
% The main function for the structures subsystem. This takes in components
% from the other subsystems and figures out the structure for them.
addpath Structures
addpath LV
addpath Plotting
addpath Payload

% [payload] = CreatePayload(1); % MicroMAS cubesat
[payload] = CreatePayload(2); % Comms satellite

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

power.mass = 23;
power.cost = 134;
power.power = 120;
 
avionics.Mass = 54;
avionics.AvgPwr = 100;
avionics.Cost = 100;

% [components] = CreateSampleComponents_Cubesat();
[components] = CreateSampleComponents_Cylinder(payload);
% [components] = CreateSampleComponents_Stacked();
components = [components, payload.comp];

[structures] = structures_main(components);

LV = LV_selection(payload,structures);

PlotSatInfo(payload,comms,power,avionics,thermal,structures,propulsion,LV)
end
