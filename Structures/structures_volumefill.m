function structures = structures_volumefill(components)
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

[inside_comp,payload] = SortedInsideComponents(components);
init_t = .0005;
[structures.structures,dim] = BuildStruct_Fill(inside_comp,payload,init_t);
structures.inside_comp = FillStruct(inside_comp,dim);
[structures.stowed_comp,structures.deploy_comp] = AttachComponents(components,structures.structures);
structures.stowed = [structures.inside_comp structures.stowed_comp];
structures.deploy = [structures.inside_comp structures.deploy_comp];

%total mass and cost calculator 
%inertia and CG calculator 

end