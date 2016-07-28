function [structures] = structures_volumefill()
% Testing out an approach to structure configuration. Starts with the
% satellite volume estimate based on average satellite density (79 kg/m^3)
% and drymass estimate. 

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
init_t = .0005;
[structures.structures,dim] = BuildStruct_Fill(inside_comp,payload,init_t);
structures.components = FillStruct(inside_comp,dim);

end