function [totMass,structures] = MassCalculator(components,structures)
load('materials.mat')

n1 = length(structures);
for i = 1:n1
% Go through each of the structures and see if the material for the
% component can be found in the materials table.
    found = 0;
    matInd = 1;
    while matInd <= length(materials) && ~found
    % Search in the materials table for the component material in order to
    % get its density.
        if strcmp(structures(i).Material,materials(matInd).Name)
            found = 1;
        end
        matInd = matInd + 1;
    end    
    if found
        if strcmp(structures(i).Shape,'Rectangle')
            h = structures(i).Dim(1);
            w = structures(i).Dim(2);
            l = structures(i).Dim(3);
            volume = h*w*l;
        elseif strcmp(structures(i).Shape,'Cylinder Hollow')
            h = structures(i).Dim(1);
            r = structures(i).Dim(2);
            t = structures(i).Dim(3);
            volume = (pi*r^2 - pi*(r-t)^2)*h;
        elseif strcmp(structures(i).Shape,'Cylinder')
            h = structures(i).Dim(1);
            r = structures(i).Dim(2);
            volume = (pi*r^2)*h; 
        end
        structures(i).Mass = materials(matInd-1).Density*volume;
    end
end

componentsMass = sum([components.Mass]);
structuresMass = sum([structures.Mass]);

totMass = componentsMass + structuresMass;