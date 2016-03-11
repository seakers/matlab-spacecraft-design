function [totalMass,inertiaTensor] = structures_main(components) % Include surfaceArea
% The main function for the structures subsystem. This takes in components
% from the other subsystems and figures out the structure for them.


[structures,buildableIndices,genParameters]= StructureBuilder(components);

counter = 1;
old.InertiaTensor = ones(3,3)*inf;
old.CG = [inf,inf,inf];
while counter <= 50;
% while the total inertia matrix doesn't reach a certain parameter,

    % Allocate the components either the first time or randomized their
    % locations the next few times around.
    if counter == 1   
        components = ComponentSort(components); % Sort the components by their mass
        components = InitialAllocateComponents(components,buildableIndices); % Assign the components to specific parts
        % Initialize the way these structures are set up.
        old.components = components;
        old.structures = structures;
        new = old;
    else
        new.structures = structures;
        new.components = LocalSearch(components,buildableIndices);
    end
    % Place the components in their locations
    [new.components,new.structures,genParameters]= ComponentConfiguration(new.components,new.structures,buildableIndices,genParameters);
    
    % Expand the satellite height if necessary.
    if any(genParameters.needExpand(:,1))
        [new.structures,genParameters] = ExpandStructure(new.structures,genParameters);
    end
    
    % Calculate the total mass of the satellite.
    [new.totalMass,new.structures] = MassCalculator(new.components,new.structures);
    
    % Calculate the inertia tensor for the new configuration of the
    % satellite
    [new.InertiaTensor,new.CG] = InertiaCalculator(new.components,new.structures);
    
    % Check the new inertia tensor compared to the old one.
    old = CheckInertia(old,new);

    counter = counter + 1;
end
% InertiaCalculator(structures);
% display(old.totalMass)
% display(old.InertiaTensor)
close all
PlotSatellite(old.components,old.structures)
totalMass = old.totalMass;
inertiaTensor = old.InertiaTensor;

function [old] = CheckInertia(old,new)
% Checks to see if the new inertia matrix passes the threshhold of what's
% acceptable or not

rold = sqrt(old.CG(1)^2+old.CG(2)^2);
rnew = sqrt(new.CG(1)^2+new.CG(2)^2);
% 
if rnew < rold
    old = new;
end




