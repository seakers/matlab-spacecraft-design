function [totalMass,InertiaTensor,STRUCTURES] = structures_main(components)

components = ComponentSort(components); % Sort the components by their mass 

counter = 1;
genParameters = initGenParameters(components);
while counter <= 100 && any(~genParameters.isFit)
    [old_structures, genParameters] = CreateStructure(genParameters);
    components = InitialAllocateComponents(components,genParameters.buildableIndices); % Assign the components to specific parts
    genParameters.needExpand = zeros(length(old_structures),4);
    
    counter2 = 1;
    keepGoing = 1;
    while keepGoing && counter2 <= length(components)  
    % Perform local search if all the components don't fit.
        new_structures = old_structures;
        [components,new_structures,genParameters]= FitComponents(components,new_structures,genParameters);
        % Allocate the components either the first time or randomized their
        % locations the next few times around.
        if any(~genParameters.isFit)
            components(logical(~genParameters.isFit)) = CleanComponents(components(logical(~genParameters.isFit)));
            components(logical(~genParameters.isFit)) = ReAllocateComponents(components(logical(~genParameters.isFit)),genParameters.buildableIndices);            
        else
            keepGoing = 0;
        end
        counter2 = counter2 + 1;
    end
    [genParameters] = UpdateParameters(genParameters);
    counter = counter +1;
end
structures = new_structures;
% counter = 1;
% old.InertiaTensor = ones(3,3)*inf;
% old.CG = [inf,inf,inf];
% while counter <= 100
%     
%     if counter == 1
%         % Initialize the way these structures are set up.
%         old.components = components;
%         old.structures = structures;
%         old.genParameters = genParameters;
%         new = old;
%     else
%         [structures, genParameters] = CreateStructure(genParameters);
%         new.structures = structures;
% %         components = CleanComponents(components);
%         new.components = ReAllocateComponents(components,genParameters.buildableIndices);
%     end
%     % Place the components in their locations
%     [new.components,new.structures,new.genParameters]= FitComponents(new.components,new.structures,genParameters);
%         
    % Statics
%     [] = Statics();
    
    % Calculate the total mass of the satellite.
[structures,structuresMass,componentsMass,totalMass] = MassCalculator(components,structures);
    
    % Calculate the inertia tensor for the new configuration of the
    % satellite
[InertiaTensor,CG] = InertiaCalculator(components,structures);
    
    % Check the new inertia tensor compared to the old one.
%     old = CheckInertia(old,new);
%     [components,structures,genParameters] = UpdateParameters(components,structures,genParameters);
%     counter = counter + 1;
% end
% [old.structures, old.genParameters] = CreateStructure(genParameters);
% totalMass = old.totalMass;
% InertiaTensor = old.InertiaTensor;
% components = old.components;
% structures = old.structures;

STRUCTURES.components = components;
STRUCTURES.structures = structures;
STRUCTURES.mass = structuresMass;


function [old] = CheckInertia(old,new)
% Checks to see if the new inertia matrix passes the threshhold of what's
% acceptable or not

rold = sqrt(old.CG(1)^2+old.CG(2)^2);
rnew = sqrt(new.CG(1)^2+new.CG(2)^2);
% 
if rnew < rold
    old = new;
end




