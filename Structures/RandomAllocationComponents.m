function components = RandomAllocationComponents(components,buildableIndices)
% Switches a randomly selected component in order to search for optimized
% location placement of components.

n1 = length(components);
n2 = buildableIndices;
ok = 0;
for i = 1:n1
    % Search through the components that aren't "Specific"
    index1 = ceil(rand()*n1);
    if strcmp('Inside',components(index1).LocationReq)  
        ok = 1;
        n2 = size(buildableIndices.Inside,1);
        index2 = ceil(rand()*n2);
        components(index1).structuresAssignment = buildableIndices.Inside(index2,:);
    elseif strcmp('Outside',components(index1).LocationReq)
        ok = 1;
        n2 = size(buildableIndices.Outside,1);
        index2 = ceil(rand()*n2);
        components(index1).structuresAssignment = buildableIndices.Outside(index2,:);
    end
end
    
