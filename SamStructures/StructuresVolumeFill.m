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

fake_comp = FakeComps();
[inside_comp,payload] = SortedInsideComponents(fake_comp);
init_t = .005;
[structures.structures,dim] = BuildStruct_Fill(inside_comp,payload,init_t);
filled_comp = FillStruct(inside_comp,dim);
[stowed_comp,deploy_comp] = AttachComponents(FakeComps,structures,dim);
structures.stowed = [filled_comp stowed_comp];
structures.deploy = [filled_comp deploy_comp];

LV = struct('id','Vega','payload_GEO',[0,0,0],'diameter',2.38,'height',3.5);

%[thermal,structures.stowed] = thermal726(dim(1),dim(2),dim(3),400,structures.stowed);

figure(1)
PlotSatellite(structures.stowed,structures.structures,LV)
figure(2)
PlotSatellite(structures.deploy,structures.structures,LV)

end