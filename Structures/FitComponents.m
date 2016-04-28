function [components,structures,genParameters] = FitComponents(components,structures,genParameters)
%%

% Fits the given component on the surface given, returning if the component
% was able to be configured and how much surface is left.
% n1 = size(components,1);
% components_temp = 

% This could be made faster if you have some sort of logical that shows
% what components have been assigned, which turns off the code when all
% components have been assigned to a place.

structuresAssignment = cat(1,components.structuresAssignment);
i = 1;
while i <= length(structures)
    j = 1;
    while j <= length(structures(i).Surface)
        index = ismember(structuresAssignment,[i,j],'rows');
        temp_comp = components(index);
        if any(index)
            % Check if there are any components assigned to this surface at
            % all.
%             while any(~isFit) 
                if strcmp(structures(i).Surface(j).buildableDir,'XY') || strcmp(structures(i).Surface(j).buildableDir,'YZ') || strcmp(structures(i).Surface(j).buildableDir,'XZ')
                % Check to see if the components are meant to be packed into
                % the plane of the panel. If not, then use the stacking
                % algorithm
                    [temp_comp,structures,genParameters.needExpand(i,:),isFit] = PackingAlgorithm(temp_comp,structures,[i,j],genParameters);    
                else
                    % If not use stacking algorithm
                    [temp_comp,structures,genParameters.needExpand(i,:)] = StackingAlgorithm(temp_comp,structures,[i,j],genParameters);
                end
                components(index) = temp_comp;
                genParameters.isFit(index) = isFit;
                structuresAssignment = cat(1,components.structuresAssignment);
%                 index = ismember(structuresAssignment,[i,j],'rows');
%             end
        end
        j =j+1;
    end
    i =i+1;
end
j = 1;


% Allocate the components to parts.
% Take the allocated components and convert them to a format the algorithm
% will understand
% Then send them to the packing algorithm.




