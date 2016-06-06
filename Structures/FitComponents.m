function [components,structures,genParameters] = FitComponents(components,structures,genParameters)
% A function that fits the given components on the structures given, based
% on what structure surface the component is assigned to. 

% In genParameters, the needExpand and isFit variables are updated to tell
% the structures that need to be expanded and the components that were able
% to be fitted, respectively.

structuresAssignment = cat(1,components.structuresAssignment);
i = 1;
while i <= length(structures)
% cycle through all the structures
    j = 1;
    while j <= length(structures(i).Surface)
    % Cycle through their surfaces
        % Find which components are assigned to the structure
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
            % If not use stacking algorithm to stack components on top of
            % each other
                [temp_comp,structures,genParameters.needExpand(i,:),isFit] = StackingAlgorithm(temp_comp,structures,[i,j],genParameters);
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




