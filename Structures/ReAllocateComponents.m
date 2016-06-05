function components = ReAllocateComponents(components,buildableIndices)
% Switches a randomly selected component in order to search for optimized
% location placement of components.

n_Components = length(components);
n_Inside = size(buildableIndices.Inside,1);
n_Outside = size(buildableIndices.Outside,1);
w_Inside = (1:n_Inside)/n_Inside;% Weights for the inside surfaces, giving the highest weights to the initial surfaces
w_Outside = (1:n_Outside)/n_Outside;% Weights for the outside surfaces, giving the highest weights to the initial surfaces

for i = 1:n_Components
    % Search through the components that aren't "Specific"
    if strcmp('Inside',components(i).LocationReq)  
        index1 = randsample(1:n_Inside,1,true,w_Inside);
        components(i).structuresAssignment = buildableIndices.Inside(index1,:);
    elseif strcmp('Outside',components(i).LocationReq)
        index1 = randsample(1:n_Outside,1,true,w_Outside);
        components(i).structuresAssignment = buildableIndices.Outside(index1,:);
    end
end
    