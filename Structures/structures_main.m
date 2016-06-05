function [STRUCTURES] = structures_main(components)

components = ComponentSort(components); % Sort the components by their mass 

% Initializing variables

nSatellites = 0;
while nSatellites <= 30
% Run this to build a certain number of satellties in order to compare said
% satellites and find the optimal one.
    ok_statics = 0;
    statics_applied = 0;
    counter = 1;
    new.genParameters = initGenParameters(components); % Create the initial parameters based on the components
    while ~ok_statics
    % While statics calculations aren't okay, keep redoing the structure.
        while  any(~new.genParameters.isFit) && counter <= 10
        % While a good structure that fits all or most of the components hasn't been created
        % yet.
            [new.genParameters] = UpdateParameters(new.genParameters); % Update the parameters used to build the new structure. If they were just initialized, nothing should be affected.
            [new.structures, new.genParameters] = CreateStructure(new.genParameters); % Create the structure based on the general parameters
            new.genParameters.needExpand = zeros(length(new.structures),4);
            
            if ~statics_applied
            % If statics calculations have not been applied yet
                new.components = InitialAllocateComponents(components,new.genParameters); % Assign the components to specific parts
            else
            % If statics calculations have been applied
                new.components = old.components;
            end
            counter2 = 1;
            ok_Fit = 0;
            while ~ok_Fit && counter2 <= 5
            % If all the components don't fit in their current locations,
            % shuffle them around first to make sure it isn't the location
            % that is just too small.
                temp_structures = new.structures; % Use this so that the structures do not get changed in case the components don't all fit initially
                [new.components,temp_structures,new.genParameters]= FitComponents(new.components,temp_structures,new.genParameters);
                % Allocate the components either the first time or randomized their
                % locations the next few times around.
                if any(~new.genParameters.isFit)
                % If there are any components that don't fit, re allocate
                % them.
                    new.components(logical(~new.genParameters.isFit)) = CleanComponents(new.components(logical(~new.genParameters.isFit)));
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
        
        [new.structures,new.structuresMass,new.structuresCost,new.componentsMass,new.totalMass] = MassCostCalculator(new.components,new.structures);
        [new.SA] = SurfaceAreaCalculator(new.genParameters.satHeight,new.genParameters.satLength,new.genParameters.satWidth);
        [new.InertiaMatrix,new.CG] = InertiaCalculator(new.components,new.structures);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Insert Statics Calculations here
        
        % This is an initial version of a statics function. It doesn't do
        % much at the moment, so please improve it as you see fit.
        % Statics(components,structures)
        ok_statics = 1;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [new.genParameters] = UpdateParameters(new.genParameters); % Update the parameters used to build the new structure    
    end
    if nSatellites == 0
    % If this is the first run of the code, just save the first satellite
    % as the "best"
        old = new;
    else
    % Compare satellites to see which one is more optimal
        old = CheckSatellites(old,new);
    end
    nSatellites = nSatellites + 1;
end

STRUCTURES = old;
STRUCTURES.width = sqrt(old.genParameters.satWidth^2+old.genParameters.satLength^2);
STRUCTURES.height = old.genParameters.satHeight;


function [old] = CheckSatellites(old,new)
% Checks to see if the new CG is in a better location or worse than the original one.

rold = sqrt(old.CG(1)^2+old.CG(2)^2);
rnew = sqrt(new.CG(1)^2+new.CG(2)^2);
% 
hold = old.CG(3);
hnew = new.CG(3);
if rnew < rold
    old = new;
end




