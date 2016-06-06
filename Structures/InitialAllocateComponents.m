function components = InitialAllocateComponents(components,genParameters)
% a function that assigns components to certain surfaces. It assigns it in
% the format of [structure index, surface on structure index] to the
% structuresAssignment field. 


% Initialize variables
n1 = length(components);
n_Inside = size(genParameters.buildableIndices.Inside,1); % number of inside surfaces
n_Outside = size(genParameters.buildableIndices.Outside,1); % number of outside surfaces
w_Inside = (n_Inside:-1:1)/n_Inside;% Weights for the inside surfaces, giving the highest weights to the initial surfaces
w_Outside = (n_Outside:-1:1)/n_Outside;% Weights for the outside surfaces, giving the highest weights to the initial surfaces

for i = 1:n1
    if strcmp(components(i).LocationReq,'Inside')
    % Check to see if the component's location requirement is inside or
    % not.
        index1 = randsample(1:n_Inside,1,true,w_Inside);
        assignment = genParameters.buildableIndices.Inside(index1,:);
    elseif strcmp(components(i).LocationReq,'Outside')
    % Check to see if the component's location requirement is Outside or
    % not and find the indices for the next location.
        index1 = randsample(1:n_Outside,1,true,w_Outside);
        assignment = genParameters.buildableIndices.Outside(index1,:);
    elseif strcmp(components(i).LocationReq,'Specific')
    % Check to see if the component's location requirement is Specific or
    % not.
        count_Specific = 1;
        % Check to see if the name of the component will be found in the
        % index of components assigned to certain structures. If it is,
        % place it there.
        componentName = components(i).Name;
        componentAssignedtoStructure = genParameters.buildableIndices.Specific(count_Specific).Name;
        while isempty(strfind(componentName,componentAssignedtoStructure))
            count_Specific = count_Specific + 1;
            componentAssignedtoStructure = genParameters.buildableIndices.Specific(count_Specific).Name;
        end
        assignment = genParameters.buildableIndices.Specific(count_Specific).Index;
    end
    components(i).structuresAssignment = assignment;
end