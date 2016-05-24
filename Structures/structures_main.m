function [STRUCTURES] = structures_main(components)

components = ComponentSort(components); % Sort the components by their mass 

counter = 1;
genParameters = initGenParameters(components);
while counter <= 50 && any(~genParameters.isFit)
    [old_structures, genParameters] = CreateStructure(genParameters);
    components = InitialAllocateComponents(components,genParameters); % Assign the components to specific parts
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
[new_structures,old.structuresMass,old.structuresCost,old.componentsMass,old.totalMass] = MassCostCalculator(components,new_structures);
[old.SA] = SurfaceAreaCalculator(genParameters.satHeight,genParameters.satLength,genParameters.satWidth);
[old.InertiaMatrix,old.CG] = InertiaCalculator(components,new_structures);

old.components = components;
old.structures = new_structures;
old.genParameters = genParameters;
% old.InertiaMatrix = ones(3,3)*inf;
% old.CG = [inf,inf,inf];
new = old;

% Perform local search for optimal placement of components
counter = 1;
while counter <= 5*length(old.components)
    
    structNotOK = 0;
    while ~structNotOK && counter <= 10
    % If, when you randomly allocate components, you accidentally move a
    % component to a place where it wouldn't fit, and only attempt this for
    % 10 times before trying again.
        new.components = RandomAllocationComponents(old.components,old.genParameters.buildableIndices);
        [new.structures, new.genParameters] = CreateStructure(old.genParameters); % This might need to be done better, pretty sure it's very inefficient/wrong here.
        % Place the components in their locations
        [new.components,new.structures,new.genParameters]= FitComponents(new.components,new.structures,new.genParameters);       
%         [new.genParameters] = UpdateParameters(new.genParameters);
%         [new.structures, new.genParameters] = CreateStructure(new.genParameters);
        if any(~genParameters.isFit)
            structNotOK = 0;
        else
            structNotOK = 1;
        end
        counter = counter + 1;
    end
        % Statics
    %     [] = Statics();

    % Calculate the total mass of the satellite.
    [new.structures,new.structuresMass,new.structuresCost,new.componentsMass,new.totalMass] = MassCostCalculator(new.components,new.structures);
    [new.SA] = SurfaceAreaCalculator(new.genParameters.satHeight,new.genParameters.satLength,new.genParameters.satWidth);
    % Calculate the inertia tensor for the new configuration of the
    % satellite
    [new.InertiaMatrix,new.CG] = InertiaCalculator(new.components,new.structures);
    
    % Check the new CG compared to the old one.
    old = CheckInertia(old,new);
    counter = counter + 1;
end
% [old.structures, old.genParameters] = CreateStructure(genParameters);
% totalMass = old.totalMass;
% InertiaMatrix = old.InertiaMatrix;
% components = old.components;
% structures = old.structures;


STRUCTURES = old;
STRUCTURES.width = sqrt(old.genParameters.satWidth^2+old.genParameters.satLength^2);
STRUCTURES.height = old.genParameters.satHeight;


function [old] = CheckInertia(old,new)
% Checks to see if the new inertia matrix passes the threshhold of what's
% acceptable or not

rold = sqrt(old.CG(1)^2+old.CG(2)^2);
rnew = sqrt(new.CG(1)^2+new.CG(2)^2);
% 
hold = old.CG(3);
hnew = new.CG(3);
if rnew < rold
    old = new;
end




