function StructuresSubsystem()

% load('sampleComponents.mat')

[components] = CreateSampleComponents_Cubesat();

[structures,genParameters]= StructureBuilder(components);
counter = 1;
old.InertiaTensor = ones(3,3)*inf;
old.CG = [inf,inf,inf];
while counter <= 50;
% while the total inertia matrix doesn't reach a certain parameter,

    % Allocate the components either the first time or randomized their
    % locations the next few times around.
    if counter == 1   
        components = ComponentSort(components); % Sort the components by their mass
        components = InitialAllocateComponents(components,genParameters.buildableIndices); % Assign the components to specific parts
        % Initialize the way these structures are set up.
        old.components = components;
        old.structures = structures;
        new = old;
    else
        new.structures = structures;
        new.components = LocalSearch(components,genParameters.buildableIndices);
    end
    % Place the components in their locations
    [new.components,new.structures,genParameters]= ComponentConfiguration(new.components,new.structures,genParameters);
    
    % Statics
%     [] = Statics();
    
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
display(old.totalMass)
display(old.InertiaTensor)
PlotSatellite(old.components,old.structures)

function [old] = CheckInertia(old,new)
% Checks to see if the new inertia matrix passes the threshhold of what's
% acceptable or not

rold = sqrt(old.CG(1)^2+old.CG(2)^2);
rnew = sqrt(new.CG(1)^2+new.CG(2)^2);
% 
if rnew < rold
    old = new;
end




