function [structures] = StructuresVolumeFill()
% Testing out an approach to structure configuration. Starts with the
% satellite volume estimate based on average satellite density (79 kg/m^3)
% and drymass estimate. 

addpath thermal72816
addpath Plotting

% Breaks down the dimensions of components that will be placed inside the
% structure into a volume metric, and tests to see if those components will
% fit inside the volume estimate. If not, increase the volume until it
% does. 

% The components that are placed inside are the filters/diplexers,
% electronics & wiring, OBC, battery, wiring (eps), 3 reaction wheels
% (which will be broken down into a cube holding all 3), and 3 magnetic
% torquers.

% Author Name: Samuel Wu 

% Testing using self-generated components, reads through component lists
% and sort inside components by mass.

fake_comp = FakeComps();
[inside_comp,payload] = SortedInsideComponents(fake_comp);

% First generate a structure using an initial guess for the thickness of
% the walls, and fill the structure with the inside components and attach
% outside components. 
init_t = .001;
[structures.structures,dim] = BuildStruct_Fill(inside_comp,payload,init_t);
filled_comp = FillStruct(inside_comp,dim);
[stowed_comp,deploy_comp] = AttachComponents(FakeComps,structures,dim);
structures.stowed = [filled_comp stowed_comp];
structures.deploy = [filled_comp deploy_comp];
structures.componentsMass = sum([inside_comp.Mass])+sum([stowed_comp.Mass]);

% Test the structure against static and dynamics loads and generate correct
% thickness to withstand loads 
[structures,final_t,material,masses] = StaticsFill(structures,dim);

% Rebuild structure and fill with components given correct thickness
[structures.structures,dim] = BuildStruct_Fill(inside_comp,payload,final_t);
structures.structures = StructuresMatMass(structures.structures,material,masses);
filled_comp = FillStruct(inside_comp,dim);
[stowed_comp,deploy_comp] = AttachComponents(FakeComps,structures,dim);
structures.stowed = [filled_comp stowed_comp];
structures.deploy = [filled_comp deploy_comp];
[structures.IM_stowed,structures.CG_stowed] = InertiaCalculator(structures.stowed,structures.structures);


LV = struct('id','Vega','payload_GEO',[0,0,0],'diameter',2.38,'height',3.5);

[Radiator,thermal,structures.stowed] = thermal726(dim(1),dim(2),dim(3),400,structures.stowed);

structures.thermal = thermal;
structures.radiator = Radiator;

figure
PlotSatellite(structures.stowed,structures.structures,LV)
figure
PlotSatellite(structures.deploy,structures.structures,LV)

end