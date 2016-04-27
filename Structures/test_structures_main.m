function test_structures_main() % Include surfaceArea
% The main function for the structures subsystem. This takes in components
% from the other subsystems and figures out the structure for them.

[components] = CreateSampleComponents_Cubesat();
% [components] = CreateSampleComponents_Cylinder();

[StructuresSub,totalMass,InertiaTensor,components,structures] = structures_main(components);


PlotSatellite(components,structures)