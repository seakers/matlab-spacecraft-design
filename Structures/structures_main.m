function [StructuresSub,totalMass,InertiaTensor,components,structures] = structures_main(components)


genParameters = initGenParameters(components);

components = ComponentSort(components); % Sort the components by their mass 

% Optimize the placement of components initially.
counter = 1;
while any(~genParameters.isFit) && counter <= 50
    [structures, genParameters] = CreateStructure(genParameters);
    components = InitialAllocateComponents(components,genParameters.buildableIndices); % Assign the components to specific parts
    genParameters.needExpand = zeros(length(structures),4);
    
    counter2 = 1;
    keepGoing = 1;
    while keepGoing && counter2 <= 5*length(components)
    % Perform local search if all the components don't fit.

        [components,structures,genParameters]= FitComponents(components,structures,genParameters);
        % Allocate the components either the first time or randomized their
        % locations the next few times around.
        if any(~genParameters.isFit)
            components(logical(genParameters.isFit)) = ReAllocateComponents(components(logical(genParameters.isFit)),genParameters.buildableIndices);
        else
            keepGoing = 0;
        end
        counter2 = counter2 + 1;
    end
    [components,structures,genParameters] = UpdateParameters(components,structures,genParameters);
    counter = counter +1;
end

counter2 = 1;
old.InertiaTensor = ones(3,3)*inf;
old.CG = [inf,inf,inf];
% while counter <= 100
%     if counter == 1
%         % Initialize the way these structures are set up.
        old.components = components;
        old.structures = structures;
        old.genParameters = genParameters;
        new = old;
%     else
%         new.structures = structures;
%         new.components = ReAllocateComponents(components,genParameters.buildableIndices);
%     end
%     % Place the components in their locations
%     counter2 = 1;
%     while counter2 <= 50
%         [new.components,new.structures,new.genParameters]= FitComponents(new.components,new.structures,genParameters);
%         
%         counter2 = counter2+1;
%     end
%     % Statics
% %     [] = Statics();
%     
%     % Calculate the total mass of the satellite.
    [old.totalMass,new.structures] = MassCalculator(new.components,new.structures);
%     
%     % Calculate the inertia tensor for the new configuration of the
%     % satellite
%     [new.InertiaTensor,new.CG] = InertiaCalculator(new.components,new.structures);
%     
%     % Check the new inertia tensor compared to the old one.
%     old = CheckInertia(old,new);
% 
%     counter = counter + 1;
% end
% InertiaCalculator(structures);
totalMass = old.totalMass;
InertiaTensor = old.InertiaTensor;
components = old.components;
structures = old.structures;
StructuresSub.Mass = cat(1,structures.Mass);

function [old] = CheckInertia(old,new)
% Checks to see if the new inertia matrix passes the threshhold of what's
% acceptable or not

rold = sqrt(old.CG(1)^2+old.CG(2)^2);
rnew = sqrt(new.CG(1)^2+new.CG(2)^2);
% 
if rnew < rold
    old = new;
end




