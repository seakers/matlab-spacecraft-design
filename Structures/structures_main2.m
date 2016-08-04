function [STRUCTURES] = structures_main2(components)
% Calculates the optimal structure for a set of inputted components.
% All dimensions are assumed to be in meters and mass in kg.
%   Inputs:
%       components      a structure array that contains all the components
%                       for the satellite, see the excel sheet for the
%                       required format of the components
%
%   Outputs:
%       STRUCTURES:     a structure variable that contains the following:
%           width       The width of the satellite
%           height      The height of the satellite
%           structures  a structure array that contains all the inidividual structures
%                       of the satellites and their information
%           components  The components structure array now with CG and
%                       inertia information
%           genParameters   a structure that contains various information
%                           about the satellite and its structure including what type of
%                           structure it is, the thickness of materials, and more
%
%   Cornell University
%   Author Name: Samuel Wu (6/13/16)
%   Author NetID: scw223

% Sort the components by their X and Y dimension and return indices to used
% for stacking and packing
% [sortedIndices] = ComponentSort(components);
% DO I WANT TO USE COMPONENT SORT? DOES IT ACTUALLY HELP/IS IT USEFUL
% COMPARED TO USING THE STACKING/PACKING ALGORITHM


nSat = 0;
while nSat <= 30
    counter = 1;
new.genParameters = initGenParameters(components); % Create the initial parameters based on the components

while  any(~new.genParameters.isFit) && counter <= 50
    % While a good structure that fits all or most of the components hasn't been created
    % yet, keep editing and updating.
    [new.genParameters] = UpdateParameters(new.genParameters); % Update the parameters used to build the new structure. If they were just initialized, nothing should be affected.

    [new.structures, new.genParameters] = CreateStructure(new.genParameters); % Create the structure based on the general parameters

    new.genParameters.needExpand = zeros(length(new.structures),4); % Zero the needExpand variable
    
	new.components = InitialAllocateComponents(components,new.genParameters); % Assign the components to specific structure surfaces initially

    counter2 = 1;
    ok_Fit = 0; % A variable to check if the components are all fitted on the satellite or not
        while ~ok_Fit && counter2 <= 5
        % If all the components don't fit in their current locations,
        % shuffle them around first to make sure that there isn't some
        % other location that is big enough to take them in before
        % resizing the satellite.
            temp_structures = new.structures; % Use this so that the structures parameters do not get changed in case the components don't all fit initially
            % a function for fitting the components
            [new.components,temp_structures,new.genParameters]= FitComponents(new.components,temp_structures,new.genParameters); 
            % Allocate the components either the first time or reallocate their
            % locations the next few times around.
            if any(~new.genParameters.isFit)
            % If there are any components that don't fit, reallocate
            % them to other spots
                % remove their previous structure assignments
                new.components(logical(~new.genParameters.isFit)) = CleanComponents(new.components(logical(~new.genParameters.isFit)));
                % reallocate them to a new structure
                new.components(logical(~new.genParameters.isFit)) = ReAllocateComponents(new.components(logical(~new.genParameters.isFit)),new.genParameters.buildableIndices);            
            else
            % If the components all fit then the structure is satisfactory
            % and it should be saved.
                ok_Fit = 1;
                new.structures = temp_structures;
            end
            counter2 = counter2 + 1;
        end
        counter = counter +1;
end
        
[new.structures,new.structuresMass,new.structuresCost,new.componentsMass,new.totalMass] = MassCostCalculator(new.components,new.structures);

new_check = Statics(new);

% Calculate the surface area of the satellite
[new_check.SA] = SurfaceAreaCalculator(new_check.genParameters.satHeight,new_check.genParameters.satLength,new_check.genParameters.satWidth);
% Calculate the inertia matrix and the CG of the current satellite
[new_check.InertiaMatrix,new_check.CG] = InertiaCalculator(new_check.components,new_check.structures);
        
    if nSat == 0
    % If this is the first run of the code, just save the first satellite
    % as the "best"
        old = new_check;
    else
    % Compare satellites to see which one is more optimal
        old = CheckSatellites(old,new_check);
    end
    nSat = nSat + 1;
end
% Save to a structure that will facilitate outputting the information
STRUCTURES = old;
% Get the overall width of the satellite [m]
STRUCTURES.width = sqrt(old.genParameters.satWidth^2+old.genParameters.satLength^2);
% Get the height of the satellite [m]
STRUCTURES.height = old.genParameters.satHeight;
end

function [old] = CheckSatellites(old,new)
% Checks to see if the new CG is in a better location or worse than the
% original one. The closer it is to zero the better, as this puts the
% satellite along the centerline of the adapter.

rold = sqrt(old.CG(1)^2+old.CG(2)^2);
rnew = sqrt(new.CG(1)^2+new.CG(2)^2);
% 
hold = old.CG(3);
hnew = new.CG(3);
if rnew < rold
    old = new;
end
end
