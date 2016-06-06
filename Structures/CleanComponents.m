function components = CleanComponents(components)
% Removes the locations, Vertices, and CG coordinates of the components,
% effectively "cleaning" them

n1 = length(components);

for i = 1:n1
    % Search through the components that aren't "Specific"
    if ~strcmp('Specific',components(i).LocationReq)
        components(i).CG_XYZ = [];
        components(i).Vertices = [];
        components(i).InertiaMatrix = [];
        components(i).RotateToSatBodyFrame = [];
        components(i).structuresAssignment = [];
    end
end