function [components,structures,genParameters] = ComponentConfiguration(components,structures,structures_buildableIndices,genParameters)
%%

genParameters.needExpand = zeros(length(structures),2);

[components,structures,genParameters] = FitComponents(components,structures,genParameters);


function [components,structures,genParameters] = FitComponents(components,structures,genParameters)
% Fits the given component on the surface given, returning if the component
% was able to be configured and how much surface is left. 
% n1 = size(components,1);
% components_temp = 

% This could be made faster if you have some sort of logical that shows
% what components have been assigned, which turns off the code when all
% components have been assigned to a place.


structures_n1 = length(structures);
structuresAssignment = cat(1,components.structuresAssignment);
for i = 1:structures_n1
        structures_n2 = length(structures(i).Surface);
        for j = 1:structures_n2
            index = ismember(structuresAssignment,[i,j],'rows');
            if any(index)
            % Check if there are any components assigned to this surface at
            % all.
                if strcmp(structures(i).Surface(j).buildableDir,'XY') || strcmp(structures(i).Surface(j).buildableDir,'YZ') || strcmp(structures(i).Surface(j).buildableDir,'XZ')
                % Check to see if the components are meant to be packed into
                % the plane of the panel. If not, then use the stacking
                % algorithm
                    [components(index),structures,genParameters.needExpand(i,:)] = PackingAlgorithm(components(index),structures,[i,j],genParameters);
                else
                % If not use stacking algorithm
                    [components(index),structures,genParameters.needExpand(i,:)]  = StackingAlgorithm(components(index),structures,[i,j],genParameters);
                end
            end
        end
end


% Allocate the components to parts.
% Take the allocated components and convert them to a format the algorithm
% will understand
% Then send them to the packing algorithm.




