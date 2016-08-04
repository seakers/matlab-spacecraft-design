function [STRUCTURES] = structures_main(components)
% Calculates the optimal structure for a set of inputted components.
% All dimensions are assumed to be in meters and mass in kg.
%   Inputs:
%       components     a structure array that contains all the components
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
%   Author Name: Anjit Fageria
%       Author Name: Samuel Wu (6/13/16)
%   Author NetID: agf46

% Sort the components by their mass 
%components = ComponentSort(components);


nSatellites = 0; % Number of satellites created to compare with each other
while nSatellites <= 30
% Run this to build a certain number of different satellties in order to
% compare said satellites and find the optimal one.
    ok_statics = 0; % Variable to check if statics safety factors are satisfied
    statics_applied = 0; % variable to check if statics calculations are applied
    counter = 1; % counter variable
    new.genParameters = initGenParameters(components); % Create the initial parameters based on the components
    while ~ok_statics
    % While statics calculations don't meet safety factor standards, keep redoing the structure.
        while  any(~new.genParameters.isFit) && counter <= 50
        % While a good structure that fits all or most of the components hasn't been created
        % yet, keep editing and updating.
            [new.genParameters] = UpdateParameters(new.genParameters); % Update the parameters used to build the new structure. If they were just initialized, nothing should be affected.
            [new.structures, new.genParameters] = CreateStructure(new.genParameters); % Create the structure based on the general parameters
            new.genParameters.needExpand = zeros(length(new.structures),4); % Zero the needExpand variable
            
            if ~statics_applied
            % If statics calculations have not been applied yet
                new.components = InitialAllocateComponents(components,new.genParameters); % Assign the components to specific structure surfaces initially
            else
            % If statics calculations have been applied
                new.components = old.components;
            end
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
        %%%%%%%%%%%%%%%%%%%%
        % Add certain warnings or outputs in case certain components don't fit?
        
        %%%%%%%%%%%%%%%%%%%%
        
        % Calculate the total mass of the satellite, the mass of the structure, and the cost of the structure due to that mass
        [new.structures,new.structuresMass,new.structuresCost,new.componentsMass,new.totalMass] = MassCostCalculator(new.components,new.structures);
        
        new_check = Statics(new);
        
        % Calculate the surface area of the satellite
        [new_check.SA] = SurfaceAreaCalculator(new_check.genParameters.satHeight,new_check.genParameters.satLength,new_check.genParameters.satWidth);
        % Calculate the inertia matrix and the CG of the current satellite
        [new_check.InertiaMatrix,new_check.CG] = InertiaCalculator(new_check.components,new_check.structures);
        
        % Statics is completed? Not sure if still need a while loop
        ok_statics = 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    end
    if nSatellites == 0
    % If this is the first run of the code, just save the first satellite
    % as the "best"
        old = new_check;
    else
    % Compare satellites to see which one is more optimal
        old = CheckSatellites(old,new_check);
    end
    nSatellites = nSatellites + 1;
end

% Save to a structure that will facilitate outputting the information
STRUCTURES = old;
% Get the overall width of the satellite [m]
STRUCTURES.width = sqrt(old.genParameters.satWidth^2+old.genParameters.satLength^2);
% Get the height of the satellite [m]
STRUCTURES.height = old.genParameters.satHeight;


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




