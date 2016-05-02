function components = ReAllocateComponents(components,buildableIndices)
% Switches a randomly selected component in order to search for optimized
% location placement of components.

n1 = length(components);
n2 = size(buildableIndices.Inside,1);
n3 = size(buildableIndices.Outside,1);

for i = 1:n1
    % Search through the components that aren't "Specific"
    if strcmp('Inside',components(i).LocationReq)  
        index1 = ceil(rand()*n2);
        components(i).structuresAssignment = buildableIndices.Inside(index1,:);
    elseif strcmp('Outside',components(i).LocationReq)
        index1 = ceil(rand()*n3);    
        components(i).structuresAssignment = buildableIndices.Outside(index1,:);
    end
end
    