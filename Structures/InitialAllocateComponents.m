function components = InitialAllocateComponents(components,genParameters)
% a function that assigns components to certain surfaces. It assigns it in
% the format of [structure index, surface on structure index] to the
% structuresAssignment field. 
n1 = length(components);
structures_buildableIndices = genParameters.buildableIndices;
n_Inside = size(structures_buildableIndices.Inside,1);
n_Outside = size(structures_buildableIndices.Outside,1);
w_Inside = (n_Inside:-1:1)/n_Inside;% Weights for the inside surfaces, giving the highest weights to the initial surfaces
w_Outside = (n_Outside:-1:1)/n_Outside;% Weights for the outside surfaces, giving the highest weights to the initial surfaces

% count_Inside = 1;
% count_Outside = 1;

%     if rectangleDim(i,2) > panelWidth && rectangleDim(i,1) > panelWidth
%     % If the component's width AND height are bigger than the panelwidth,
%     % then put it in the unable to fit pile.
%         isFit(i) = 0;
%     elseif rectangleDim(i,2) > panelWidth && rectangleDim(i,1) < panelWidth
%     % If the component's width is larger than the panelwidth, but the
%     % height isn't switch the two.
%         w = rectangleDim(i,2);
%         rectangleDim(i,2) = rectangleDim(i,1);
%         rectangleDim(i,1) = w;
%         isFit(i) = 1;
% end


for i = 1:n1
%     if ~genParameters.isFit(i)
        if strcmp(components(i).LocationReq,'Inside')
        % Check to see if the component's location requirement is inside or
        % not.
            index1 = randsample(1:n_Inside,1,true,w_Inside);
            assignment = structures_buildableIndices.Inside(index1,:);
%             if count_Inside >= n_Inside
%                 count_Inside = 1;
%             else
%                 count_Inside = count_Inside + 1;
%             end
        elseif strcmp(components(i).LocationReq,'Outside')
        % Check to see if the component's location requirement is Outside or
        % not and find the indices for the next location.
            index1 = randsample(1:n_Outside,1,true,w_Outside);
            assignment = structures_buildableIndices.Outside(index1,:);
%             if count_Outside >= n_Outside
%                 count_Outside = 1;
%             else
%                 count_Outside = count_Outside + 1;
%             end
        elseif strcmp(components(i).LocationReq,'Specific')
        % Check to see if the component's location requirement is Specific or
        % not.
            count_Specific = 1;
            % Check to see if the name of the component will be found in the
            % index of components assigned to certain structures.     
            componentName = components(i).Name;
            componentAssignedtoStructure = structures_buildableIndices.Specific(count_Specific).Name;
            while isempty(strfind(componentName,componentAssignedtoStructure))
                count_Specific = count_Specific + 1;
                componentAssignedtoStructure = structures_buildableIndices.Specific(count_Specific).Name;
            end
            assignment = structures_buildableIndices.Specific(count_Specific).Index;
        end
        components(i).structuresAssignment = assignment;
%     end
end