function test_structures_main() % Include surfaceArea
% The main function for the structures subsystem. This takes in components
% from the other subsystems and figures out the structure for them.


payload.Mass = 100;
payload.Power = 120;
payload.Cost = 50;

comms.mass = 50;
comms.cost = 12;
comms.power = 120;

thermal.mass = 34;
thermal.cost = 123;
thermal.power = 120;

power.mass = 23;
power.cost = 134;
power.power = 120;
 
avionics.Mass = 54;
avionics.Power = 100;
avionics.Cost = 100;

[components] = CreateSampleComponents_Cubesat();
% [components] = CreateSampleComponents_Cylinder();

[totalMass,InertiaTensor,structures] = structures_main(components);


PlotSatInfo(payload,comms,power,avionics,thermal,structures)
